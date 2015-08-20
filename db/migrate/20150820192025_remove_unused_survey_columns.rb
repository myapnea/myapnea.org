class RemoveUnusedSurveyColumns < ActiveRecord::Migration
  def up
    remove_index :surveys, :first_question_id
    remove_column :surveys, :first_question_id
    remove_column :surveys, :tsorted_nodes
    remove_column :surveys, :longest_time
    remove_column :surveys, :longest_path
    remove_column :surveys, :report_name
  end

  def down
    add_column :surveys, :report_name, :string
    add_column :surveys, :longest_path, :integer
    add_column :surveys, :longest_time, :decimal
    add_column :surveys, :tsorted_nodes, :text
    add_column :surveys, :first_question_id, :integer
    add_index :surveys, :first_question_id
  end
end
