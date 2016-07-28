class RenameQuestionFlowToSurvey < ActiveRecord::Migration[4.2]
  def change
    rename_table :question_flows, :surveys
    rename_column :answer_sessions, :question_flow_id, :survey_id
    rename_column :question_edges, :question_flow_id, :survey_id
    rename_column :survey_question_orders, :question_flow_id, :survey_id
  end
end
