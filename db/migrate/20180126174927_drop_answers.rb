class DropAnswers < ActiveRecord::Migration[5.2]
  def change
    drop_table :answers do |t|
      t.integer :question_id
      t.integer :answer_session_id
      t.integer :user_id
      t.string :state, null: false, default: "incomplete"
      t.boolean :preferred_not_to_answer, null: false, default: false
      t.timestamps
      t.index [:answer_session_id, :question_id], unique: true
      t.index :answer_session_id
      t.index :question_id
      t.index :state
    end
  end
end
