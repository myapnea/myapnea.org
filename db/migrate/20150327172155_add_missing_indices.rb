class AddMissingIndices < ActiveRecord::Migration
  def change
    add_index :questions, :slug
    add_index :survey_question_orders, :survey_id
    add_index :survey_question_orders, :question_id
    add_index :surveys, :slug
    add_index :answers, :state
    add_index :question_edges, :parent_question_id
    add_index :question_edges, :child_question_id
    add_index :question_edges, :direct

    add_index :answer_sessions, :deleted
    add_index :answers, :deleted
  end
end
