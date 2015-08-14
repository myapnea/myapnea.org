class AddLockedAtToAnswerSessions < ActiveRecord::Migration
  def change
    add_column :answer_sessions, :locked_at, :datetime
  end
end
