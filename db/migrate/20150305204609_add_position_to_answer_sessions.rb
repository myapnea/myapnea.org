class AddPositionToAnswerSessions < ActiveRecord::Migration[4.2]
  def up
    add_column :surveys, :default_position, :integer, null: false, default: 99999
    add_column :answer_sessions, :position, :integer
    change_column :answer_sessions, :locked, :boolean, null: false, default: false
    add_index :answer_sessions, :locked
    add_index :answer_sessions, :encounter
    add_index :answer_sessions, :position
  end

  def down
    remove_index :answer_sessions, :position
    remove_index :answer_sessions, :encounter
    remove_index :answer_sessions, :locked
    change_column :answer_sessions, :locked, :boolean, null: true, default: nil
    remove_column :answer_sessions, :position
    remove_column :surveys, :default_position
  end
end
