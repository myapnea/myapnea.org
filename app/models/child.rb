# frozen_string_literal: true

# TODO: Deprecated in v17.0.0

# Allows members to fill out surveys for by child.
class Child < ApplicationRecord
  # Callbacks
  after_save :assign_child_surveys

  # Concerns
  include Deletable

  # Scopes

  # Model Validation
  validates :first_name, :age, :user_id, presence: true
  validates :age, numericality: { greater_than_or_equal_to: 2, less_than_or_equal_to: 8 }

  # Model Relationships
  belongs_to :user
  has_many :answer_sessions, -> { where deleted: false }

  # Model Methods

  def sorted_answer_sessions
    answer_sessions.joins(:survey).where.not(surveys: { slug: nil }).order(:locked, 'surveys.name_en', :encounter)
  end

  def consented?
    accepted_consent_at.present? && accepted_consent_at < Time.zone.now
  end

  private

  def assign_child_surveys
    remove_out_of_range_child_answer_sessions!
    user_type = 'caregiver_child'
    Survey.current.viewable.pediatric.where('surveys.child_min_age <= ? and surveys.child_max_age >= ?', age, age).joins(:survey_user_types).merge(SurveyUserType.current.where(user_type: user_type)).each do |survey|
      unless survey.pediatric_diagnosed? && !diagnosed?
        survey.encounters.where(launch_days_after_sign_up: 0).each do |encounter|
          answer_sessions.where(encounter: encounter.slug, survey_id: survey.id, user_id: self.user_id).first_or_create
        end
      end
    end
  end

  def remove_out_of_range_child_answer_sessions!
    answer_sessions.joins(:survey).where.not('surveys.child_min_age <= ? and surveys.child_max_age >= ?', age, age).each do |answer_session|
      answer_session.destroy if answer_session.answers.count == 0
    end
  end
end
