class AddPositionToAnswerSessions < ActiveRecord::Migration[4.2]
  def change
    add_column :surveys, :default_position, :integer, null: false, default: 99999
    add_column :answer_sessions, :position, :integer
    change_column :answer_sessions, :locked, :boolean, null: false, default: false


    add_index :answer_sessions, :locked
    add_index :answer_sessions, :encounter
    add_index :answer_sessions, :position


  end
end
