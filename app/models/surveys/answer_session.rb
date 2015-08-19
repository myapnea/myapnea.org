class AnswerSession < ActiveRecord::Base
  # Concerns
  include Deletable

  # Associations
  belongs_to :survey
  belongs_to :user
  belongs_to :child
  has_many :answers, -> { where deleted: false }
  has_many :reports

  # Validations
  validates_presence_of :survey_id, :encounter
  validates_uniqueness_of :survey_id, scope: [:encounter, :user_id, :child_id, :deleted]

  # Model Methods
  def self.most_recent(survey_id, user_id)
    answer_sessions = AnswerSession.current.where(survey_id: survey_id, user_id: user_id).order(updated_at: :desc)
    answer_sessions.empty? ? nil : answer_sessions.first
  end

  def completed?
    answers.complete.count == survey.questions.count
  end

  def unlocked?
    !self.locked?
  end

  def available_for_user_types?(user_types)
    self.survey.survey_user_types.where(user_type: user_types).count > 0
  end

  def process_answer(question, response)
    answer = atomic_first_or_create_answer(question)
    if answer.locked?
      nil
    else
      answer.update_response_value!(response)
      answer
    end
  end

  def atomic_first_or_create_answer(question)
    begin
      self.answers.where(question_id: question.id).first_or_create!
    rescue ActiveRecord::RecordNotUnique
      retry
    end
  end

  def lock!
    self.answers.update_all state: 'locked'
    self.update locked: true, locked_at: Time.zone.now
  end

  def unlock!
    self.answers.where(state: 'locked').update_all(state: 'complete')
    self.update locked: false, locked_at: nil
  end

  # Returns all answer values for a specific question and answer template
  def answer_values(question, answer_template)
    AnswerValue.joins(:answer).where(answers: { answer_session_id: self.id, question_id: question.id }).where(answer_template_id: answer_template.id)
  end

  def applicable_questions
    # all questions in answer session's answers
    Question.joins(:answers).where(answers: { answer_session_id: self.id })
  end

  def percent_completed
    if survey.questions.count > 0
      (answers.complete.count * 100.0 / survey.questions.count).round
    else
      100
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
end
