class RemoveQuestionEdgeTable < ActiveRecord::Migration
  def up
    remove_index :question_edges, :parent_question_id
    remove_index :question_edges, :child_question_id
    remove_index :question_edges, :direct
    drop_table :question_edges
  end

  def down
    create_table :question_edges do |t|
      t.integer :survey_id
      t.integer :parent_question_id
      t.integer :child_question_id
      t.string :condition
      t.boolean :direct
      t.integer :count

      t.timestamps
    end
    add_index :question_edges, :parent_question_id
    add_index :question_edges, :child_question_id
    add_index :question_edges, :direct
  end
end
