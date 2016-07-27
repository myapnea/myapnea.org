class RemoveRemainingTimeAndDistanceFromSurveyQuestionOrders < ActiveRecord::Migration[4.2]
  def change
    remove_column :survey_question_orders, :remaining_time, :float
    remove_column :survey_question_orders, :remaining_distance, :integer
  end
end
