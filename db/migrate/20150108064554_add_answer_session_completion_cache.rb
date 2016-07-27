class AddAnswerSessionCompletionCache < ActiveRecord::Migration[4.2]
  def change
    add_column :answer_sessions, :completed, :boolean
  end
end
