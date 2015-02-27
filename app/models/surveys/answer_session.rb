class AnswerSession < ActiveRecord::Base
  # Concerns
  include Deletable

  # Associations
  belongs_to :survey
  belongs_to :first_answer, class_name: "Answer", foreign_key: "first_answer_id"
  belongs_to :last_answer, class_name: "Answer", foreign_key: "last_answer_id"
  belongs_to :user
  has_many :answer_edges
  has_many :answers, -> { where deleted: false }


  # Validations
  # Unique in terms of survey/encounter
  validates :survey_id, uniqueness: { scope: [:encounter, :user_id] }
  validates :encounter, presence: true

  # Class Methods
  def self.most_recent(survey_id, user_id)
    answer_sessions = AnswerSession.current.where(survey_id: survey_id, user_id: user_id).order(updated_at: :desc)
    answer_sessions.empty? ? nil : answer_sessions.first
  end

  def self.find_or_create(user, survey)
    answer_sessions = AnswerSession.current.where(user_id: user.id, survey_id: survey.id).order(updated_at: :desc)

    if answer_sessions.empty?
      AnswerSession.create(user_id: user.id, survey_id: survey.id)
    else
      answer_sessions.first
    end
  end

  # Instance Methods
  def incomplete_answers
    answers.incomplete
  end

  def completed_answers
    answers.complete
  end

  def completed?
    unless self[:completed]
      update_attribute(:completed, total_remaining_path_length == 0)
    end

    self[:completed]
  end

  def process_answer(question, params)
    answer = answers.where(question_id: question.id).first || answers.build(question_id: question.id)

    if answer.locked?
      nil
    else
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
  end

  def lock_answers
    answers.each do |answer|
      answer.update(state: "locked")
    end
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




  ## Deprecated - remove in 6.0.0
  # def all_reportable_answers
  #   answers.joins(answer_values: :answer_template).where("\"answer_templates\".data_type = 'answer_option_id'").where('"answer_values".answer_option_id is not null')
  # end


  # TODO: Can we just use the association?
  # def answers
  #   Answer.current
  #       .joins('left join answer_edges parent_ae on parent_ae.child_answer_id = "answers".id')
  #       .joins('left join answer_edges child_ae on child_ae.parent_answer_id = "answers".id')
  #       .where(answer_session_id: self.id)
  #       .where("parent_ae.child_answer_id is not null or child_ae.parent_answer_id is not null")
  #
  # end


  # def grouped_reportable_answers
  #   all_reportable_answers.includes(question: :question_help_message).group_by{|a| a.question.question_help_message ? a.question.question_help_message.message : ""}
  #
  # end

  # def reset_completion
  #   if first_answer.present?
  #     #connected_answers = all_answers
  #     first_answer.destroy_descendant_edges
  #     self.first_answer = nil
  #     self.last_answer = nil
  #     self.completed = false
  #     save
  #     #connected_answers.each(&:destroy)
  #   end
  # end

  # def path_length_to_answer(answer)
  #   if last_answer.blank?
  #     coll = []
  #     current_answer = answer
  #   elsif answer.nil? or answer.new_record?
  #     coll = [answer]
  #     current_answer = last_answer
  #   else
  #     current_answer = answer.clone
  #     coll = []
  #   end
  #
  #   while current_answer
  #     coll << current_answer
  #     current_answer = current_answer.previous_answer
  #   end
  #
  #   coll.length
  # end


  ##

  def get_answer(question_id)
    Answer.current.joins(:question).where(questions: {id: question_id}).where(answer_session_id: self.id).order("updated_at desc").limit(1).first
  end

  def started?
    last_answer.present?
  end

  def next_question
    if completed?
      nil
    elsif started?
      last_answer.next_question
    else
      survey.first_question
    end
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
    survey.total_questions or completed_path_length + remaining_path_length(last_answer)
  end

  def percent_completed
    (completed_path_length.to_f / total_path_length.to_f) * 100.0
  end

  def destroy
    update_column :deleted, true
    answers.each do |a|
      a.destroy
    end
  end

  private

end
