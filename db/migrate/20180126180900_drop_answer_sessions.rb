class DropAnswerSessions < ActiveRecord::Migration[5.2]
  def change
    drop_table :answer_sessions do |t|
      t.integer :user_id
      t.integer :survey_id
      t.boolean :completed
      t.boolean :deleted, default: false, null: false
      t.string :encounter
      t.boolean :locked, default: false, null: false
      t.integer :position
      t.integer :child_id, default: 0, null: false
      t.datetime :locked_at
      t.timestamps
      t.index :child_id
      t.index :deleted
      t.index :encounter
      t.index :locked
      t.index :position
      t.index [:survey_id, :encounter, :user_id, :child_id, :deleted], unique: true, name: "answer_sessions_idx"
      t.index :survey_id
      t.index :user_id
    end
  end
end
