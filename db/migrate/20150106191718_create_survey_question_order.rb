class CreateSurveyQuestionOrder < ActiveRecord::Migration
  def change
    create_table :survey_question_orders do |t|
      t.references :question_flow
      t.references :question
      t.integer :question_number
    end

    add_index :survey_question_orders, [:question_flow_id, :question_id], name: :index_sqo_on_qf_and_q
  end
end
