class AddLockedAtToAnswerSessions < ActiveRecord::Migration[4.2]
  def change
    add_column :answer_sessions, :locked_at, :datetime
  end
end
