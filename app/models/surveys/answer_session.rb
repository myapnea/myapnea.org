class AnswerSession < ActiveRecord::Base
  # Concerns
  include Deletable

  # Associations
  belongs_to :survey
  belongs_to :first_answer, class_name: "Answer", foreign_key: "first_answer_id"
  belongs_to :last_answer, class_name: "Answer", foreign_key: "last_answer_id"
  belongs_to :user
  belongs_to :child
  has_many :answer_edges
  has_many :answers, -> { where deleted: false }
  has_many :reports

  # Validations
  validates_presence_of :survey_id, :encounter
  validates_uniqueness_of :survey_id, scope: [:encounter, :user_id, :child_id]

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
    answers.complete.count == survey.questions.count
  end

  def locked?
    unless self[:locked]
      update(locked: (answers.locked.count == survey.questions.count))
    end

    self[:locked]
  end

  def process_answer(question, params)
    answer = answers.where(question_id: question.id).first || answers.build(question_id: question.id)

    if answer.locked?
      nil
    else
      # New Record: do everything
      answer_modified = false

      # We want to update if answer is new, or answer value used to be blank.
      #if answer.new_record? or answer.string_value != params[question.to_param] or answer.show_value.blank?
      # Set Value and Save
      answer.value = params[question.to_param]
      answer.save
      answer_modified = true
      #end

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

  def lock
    answers.each do |answer|
      answer.update(state: "locked")
    end
  end

  def unlock
    answers.each {|answer| answer.update(state: 'incomplete')}
    update(locked: false)
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


  def percent_completed
    if survey.questions.count > 0
      answers.complete.count * 100.0 / survey.questions.count
    else
      100.0
    end
  end

  def destroy
    update_column :deleted, true
    answers.each do |a|
      a.destroy
    end
  end

  def position
    self[:position] || survey.default_position
  end

  private

end
