class UpdateChildIdDefaultsForAnswerSessions < ActiveRecord::Migration[5.0]
  def up
    change_column :answer_sessions, :child_id, :integer, null: false, default: 0
  end

  def down
    change_column :answer_sessions, :child_id, :integer, null: true, default: nil
  end
end
