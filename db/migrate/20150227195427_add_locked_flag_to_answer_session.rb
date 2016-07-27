class AddLockedFlagToAnswerSession < ActiveRecord::Migration[4.2]
  def change
    add_column :answer_sessions, :locked, :boolean
  end
end
