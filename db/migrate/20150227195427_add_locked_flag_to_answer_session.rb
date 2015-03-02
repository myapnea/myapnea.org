class AddLockedFlagToAnswerSession < ActiveRecord::Migration
  def change
    add_column :answer_sessions, :locked, :boolean
  end
end
