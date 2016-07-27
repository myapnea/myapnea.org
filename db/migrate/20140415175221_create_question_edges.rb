class CreateQuestionEdges < ActiveRecord::Migration[4.2]
  def change
    create_table :question_edges do |t|
      t.integer :question_flow_id
      t.integer :parent_question_id
      t.integer :child_question_id
      t.string :condition
      t.boolean :direct
      t.integer :count

      t.timestamps
    end
  end
end
