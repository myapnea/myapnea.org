class QuestionEdge < ActiveRecord::Base
  belongs_to :survey
  belongs_to :parent_question, class_name: "Question"
  belongs_to :child_question, class_name: "Question"

  acts_as_dag_links node_class_name: 'Question', ancestor_id_column: 'parent_question_id', descendant_id_column: 'child_question_id'

  def self.build_edge(ancestor, descendant, condition = nil, qf_id = Survey.first.id)
    source = self::EndPoint.from(ancestor)
    sink = self::EndPoint.from(descendant)
    conditions = self.conditions_for(source, sink)
    conditions[:condition] = condition
    path = self.new(conditions)
    path.make_direct
    path.survey_id = qf_id
    path
  end
end
