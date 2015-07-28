class Child < ActiveRecord::Base

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

end


