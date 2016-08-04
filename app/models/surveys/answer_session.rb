# frozen_string_literal: true

class AnswerSession < ApplicationRecord
  # Concerns
  include Deletable

  # Associations
  belongs_to :survey
  belongs_to :user
  belongs_to :child
  has_many :answers

  # Validations
  validates :survey_id, :encounter, presence: true
  validates :survey_id, uniqueness: { scope: [:encounter, :user_id, :child_id, :deleted] }

  # Scopes
  scope :no_child, -> { where child_id: 0 }

  # Model Methods
  def completed?
    answers.where(question_id: survey.questions.unarchived.pluck(:id)).complete.count == survey.questions.unarchived.count
  end

  def unlocked?
    !locked?
  end

  def available_for_user_types?(user_types)
    survey.survey_user_types.where(user_type: user_types).count > 0
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
    answers.where(question_id: question.id).first_or_create!
  rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid
    retry
  end

  def lock!
    answers.update_all state: 'locked'
    update locked: true, locked_at: Time.zone.now
  end

  def unlock!
    answers.where(state: 'locked').update_all(state: 'complete')
    update locked: false, locked_at: nil
  end

  # Returns all answer values for a specific question and answer template
  def answer_values(question, answer_template)
    AnswerValue.joins(:answer).where(answers: { answer_session_id: id, question_id: question.id }).where(answer_template_id: answer_template.id)
  end

  def percent_completed
    if survey.questions.unarchived.count > 0
      (answers.where(question_id: survey.questions.unarchived.pluck(:id)).complete.count * 100.0 / survey.questions.unarchived.count).round
    else
      100
    end
  end

  def destroy
    update_column :deleted, true
    answers.destroy_all
  end
end
