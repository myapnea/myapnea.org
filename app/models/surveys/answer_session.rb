class AnswerSession < ActiveRecord::Base
  include Deletable

  belongs_to :survey
  belongs_to :first_answer, class_name: "Answer", foreign_key: "first_answer_id"
  belongs_to :last_answer, class_name: "Answer", foreign_key: "last_answer_id"
  belongs_to :user
  has_many :answer_edges

  # Class Methods

  def self.most_recent(survey_id, user_id)
    answer_sessions = AnswerSession.current.where(survey_id: survey_id, user_id: user_id).order(updated_at: :desc)
    answer_sessions.empty? ? nil : answer_sessions.first
  end

  def completed_answers
    answers

    # if first_answer
    #   Answer.joins(:in_edge).where(answer_session_id: self.id).select{|a| a.in_edge.present? }.append(first_answer)
    # else
    #   []
    # end
  end

  def completed?
    unless self[:completed]
      update_attribute(:completed, total_remaining_path_length == 0)
    end

    self[:completed]
  end

  def process_answer(question, params)
    # adding should always be at tail!

    # Create answer object
    # Create answer edge from tail to new answer

    #answer_values =


    # Create new or find old answer object
    answer = Answer.current.where(question_id: question.id, answer_session_id: self.id).first || Answer.new(question_id: question.id, answer_session_id: self.id)

    # Options:
    # If new, create answer values and save
    #   also, since we're always adding new answers at the tail, set edge from end to new answer, and set new end

    # If existing
    ## If value is changing
    ### set new value
    #### if more than one possible route out
    ##### destroy descendents and set last_answer to this one
    #### else, do nothing
    ## else do nothing

    #

=begin
  new record that's also the first answer in answer session:
    - set value
    - save
    - set to first answer
    - set to last answer
  new record in an existing answer session
    - set value
    - save
    - set edge from previous answer
    - set to last answer

  existing record with new value(s) and multiple downstream options and no in edge and is first answer
    - set value
    - save
    - destroy downstream edges
    - set to last answer

  existing record with new value(s) and multiple downstream options and no in edge
    - set value
    - save
    - destroy downstream edges
    - set edge from previous answer
    - set to last answer

  existing record with new value(s) and multiple downstream options and an in edge
    - set value
    - save
    - destroy downstream edges
    - set to last answer

  existing record with new value(s) and one downstream option and no in edge and is first answer
    - set value
    - save

  existing record with new value(s) and one downstream option and no in edge
    - set value
    - save
    - set edge from previous answer
    - set to last answer


  existing record with new value(s) one downstream option and an in edge
    - set value
    - save

  existing record with no new values and is first and no in edge
    - nothing!!

  existing record with no new values and no in edge
    - set edge from previous answer
    - set to last answer

  existing record with no new values and an in edge
    - nothing!!




  new record: do everything


  existing record with
=end
    # New Record: do everything
    answer_modified = false

    if answer.new_record? or answer.string_value != params[question.id.to_s]
      # Set Value and Save

      answer.value = params[question.id.to_s]
      answer.save
      answer_modified = true
    end

    if first_answer_id.blank?
      # if no first answer, set it!
      self[:first_answer_id] = answer.id
      self[:last_answer_id] = answer.id
    elsif answer.in_edge.blank? and self[:first_answer_id] != answer.id
      # No in edge (and not first answer)...you need to set it
      answer_edges.create(parent_answer_id: last_answer.id, child_answer_id: answer.id)
      self[:last_answer_id] = answer.id
    end

    if answer_modified and answer.multiple_options?
      answer.destroy_descendant_edges
      self[:last_answer_id] = answer.id
    end

    self.save

    answer
  end

  ## Optimized (mostly)
  def applicable_questions
    # all questions in answer session's answers
    Question
        .joins(:answers)
        .joins('left join answer_edges parent_ae on parent_ae.child_answer_id = "answers".id')
        .joins('left join answer_edges child_ae on child_ae.parent_answer_id = "answers".id')
        .where(answers: { answer_session_id: self.id} )
        .where("parent_ae.child_answer_id is not null or child_ae.parent_answer_id is not null")
  end


  def answers
    Answer.current
        .joins('left join answer_edges parent_ae on parent_ae.child_answer_id = "answers".id')
        .joins('left join answer_edges child_ae on child_ae.parent_answer_id = "answers".id')
        .where(answer_session_id: self.id)
        .where("parent_ae.child_answer_id is not null or child_ae.parent_answer_id is not null")

  end

  def all_answers
    answers

  end

  def all_reportable_answers
    #all_answers.select {|answer| answer.answer_values.map{|av| av.answer_template.data_type }.include? "answer_option_id" and answer.show_value.present? } if all_answers
    answers.distinct.joins(answer_values: :answer_template).where("\"answer_templates\".data_type = 'answer_option_id'").where('"answer_values".answer_option_id is not null')

  end

  def grouped_reportable_answers
    all_reportable_answers.includes(question: :question_help_message).group_by{|a| a.question.question_help_message ? a.question.question_help_message.message : ""}

  end

  def get_answer(question_id)
    Answer.current.joins(:question).where(questions: {id: question_id}).where(answer_session_id: self.id).order("updated_at desc").limit(1).first
  end

  def started?
    last_answer.present?
  end

  def reset_completion
    if first_answer.present?
      #connected_answers = all_answers
      first_answer.destroy_descendant_edges
      self.first_answer = nil
      self.last_answer = nil
      self.completed = false
      save
      #connected_answers.each(&:destroy)
    end
  end

  def path_length_to_answer(answer)
    if last_answer.blank?
      coll = []
      current_answer = answer
    elsif answer.nil? or answer.new_record?
      coll = [answer]
      current_answer = last_answer
    else
      current_answer = answer.clone
      coll = []
    end

    while current_answer
      coll << current_answer
      current_answer = current_answer.previous_answer
    end

    coll.length
  end




  def completed_path_length
    completed_answers.count
  end

  def remaining_path_length(from_answer)
    if from_answer.nil?
      total_remaining_path_length
    elsif from_answer.next_question.present?
      survey.path_length(from_answer.next_question)
    else
      0
    end

  end

  def total_remaining_path_length
    if last_answer.blank?
      survey.longest_path_length
    elsif last_answer.next_question.nil?
      0
    else
      survey.path_length(last_answer.next_question)
    end
  end

  def total_path_length
    completed_path_length + remaining_path_length(last_answer)
  end

  def percent_completed
    (completed_path_length.to_f / total_path_length.to_f) * 100.0
  end

  def destroy
    update_column :deleted, true
    all_answers.each do |a|
      a.destroy
    end
  end

  private

end
