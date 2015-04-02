class Question < ActiveRecord::Base
  # Associations
  has_and_belongs_to_many :answer_templates, -> { order "answer_templates.created_at asc" }
  belongs_to :group
  has_many :answers, -> { where deleted: false }
  belongs_to :question_help_message
  has_many :survey_answer_frequencies
  has_many :votes
  has_many :reports

  # Concerns
  include Localizable
  include Votable
  include Authority::Abilities


  localize :text
  self.authorizer_name = "OwnerAuthorizer"

  ## DAG
  has_dag_links :link_class_name => 'QuestionEdge'

  def next_question(survey)
    candidate_edges(survey).first
  end

  def previous_question(survey)
    candidate_edges(survey).first
  end

  def default_next_question(survey)
    ce = candidate_edges(survey)
    ce.present? ? ce.select {|edge| edge.condition.blank? }.first.descendant : nil
  end

  def default_previous_question(survey)
    ce = candidate_edges(survey)
    ce.present? ? ce.select {|edge| edge.condition.blank? }.first.ancestor : nil
  end

  def conditional_children(survey)
    candidate_edges(survey).select {|edge| edge.condition.present? }.map(&:descendant)
  end

  def parent
    parents.first unless parents.blank?
  end
  ##

  def answer_templates=(attribute_list)
    attribute_list.each do |attrs|
      answer_templates.build(attrs)
    end
  end

  def applicable_to_user?(answer_session)
    answer_session.applicable_questions.where(id: self.id).exists?
  end

  def user_skipped_question?(answer_session)
    applicable_to_user?(answer_session) and (answer_session.answers.where(question_id: self.id).select{|answer| answer.show_value.blank?}.exists?)
  end
  ## End Reports

  private

  def candidate_edges(survey)
    QuestionEdge.where(parent_question_id: self[:id], survey_id: survey.id, direct: true)
  end
end
