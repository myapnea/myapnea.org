class DropSurveyQuestionOrders < ActiveRecord::Migration[5.2]
  def change
    drop_table :survey_question_orders do |t|
      t.integer :survey_id
      t.integer :question_id
      t.integer :position
      t.index [:question_id]
      t.index [:survey_id, :question_id], name: :index_sqo_on_qf_and_q
      t.index [:survey_id]
    end
  end
end
