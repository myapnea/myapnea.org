class Child < ActiveRecord::Base

  # Callbacks
  after_save :assign_child_surveys

  # Concerns
  include Deletable

  # Named Scopes

  # Model Validation
  validates_presence_of :first_name, :age, :user_id
  validates_numericality_of :age, greater_than_or_equal_to: 0, less_than_or_equal_to: 8

  # Model Relationships
  belongs_to :user
  has_many :answer_sessions, -> { where deleted: false }

  # Model Methods

  def sorted_answer_sessions
    self.answer_sessions.joins(:survey).where.not(surveys: { slug: nil }).order(:locked, "surveys.name_en", :encounter)
  end

  def consented?
    self.accepted_consent_at and self.accepted_consent_at < Time.zone.now
  end

  private

    def assign_child_surveys
      remove_out_of_range_child_answer_sessions!
      user_type = 'caregiver_child'
      Survey.current.viewable.pediatric.where("surveys.child_min_age <= ? and surveys.child_max_age >= ?", self.age, self.age).joins(:survey_user_types).merge(SurveyUserType.current.where(user_type: user_type)).each do |survey|
        survey.encounters.where(launch_days_after_sign_up: 0).each do |encounter|
          self.answer_sessions.where(encounter: encounter.slug, survey_id: survey.id, user_id: self.user_id).first_or_create
        end
      end
    end

    def remove_out_of_range_child_answer_sessions!
      self.answer_sessions.joins(:survey).where.not("surveys.child_min_age <= ? and surveys.child_max_age >= ?", self.age, self.age).each do |answer_session|
        if answer_session.answers.count == 0
          answer_session.destroy
        end
      end
    end

end


