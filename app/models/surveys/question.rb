class Question < ActiveRecord::Base
  # Associations
  has_and_belongs_to_many :answer_templates, -> { order "created_at asc" }
  belongs_to :group
  has_many :answers, -> { where deleted: false }
  belongs_to :question_help_message
  has_many :survey_answer_frequencies
  has_many :votes

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

  ## Deprecated

  # def is_branchpoint?(survey)
  #   QuestionEdge.where(parent_question_id: self[:id], survey_id: survey.id, direct: true).length > 1
  # end

  # def part_of_group?
  #   group.present?
  # end

  # def group_member?(q)
  #   group_members.include? q
  # end

  # def group_members
  #   if part_of_group?
  #     group.questions
  #   else
  #     nil
  #   end
  #
  # end

  # def answer_frequencies
  #   if answer_templates.length == 1 and ["multiple_choice", "check_box"].include? answer_templates.first.display_type.name
  #
  #
  #     at = answer_templates.includes(:answer_options).first
  #     all_options = at.answer_options.to_a
  #
  #     groups = []
  #
  #     all_options.each do |o|
  #       groups << {label: o.value, answers: [], count: 0, frequency: 0.0}
  #     end
  #
  #     valid_answers = answers
  #                         .includes(answer_values: :answer_option).includes(answer_values: :answer_template)
  #     total_answers = valid_answers.count
  #
  #     valid_answers.group_by{|av| av.show_value}.each_pair do |key, array|
  #       g = groups.find{|x| x[:label] == key }
  #       if g
  #         g[:answers] = array
  #         g[:count] = array.count
  #         g[:frequency] = array.count/total_answers.to_f
  #       end
  #     end
  #
  #     groups
  #
  #   end
  #
  # end
  ## end Deprecated

  # def graph_frequencies
  #   groups = answers.group_by{|answer| answer.value}
  #   groups.inject({}) {|h, (k,v)| h[k] = v.length; h}
  # end


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
