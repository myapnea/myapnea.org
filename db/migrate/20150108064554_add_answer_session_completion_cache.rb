class AddAnswerSessionCompletionCache < ActiveRecord::Migration
  def change
    add_column :answer_sessions, :completed, :boolean
  end
end
