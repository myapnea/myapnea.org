class AddEncountersToAnswerSession < ActiveRecord::Migration
  def change
    add_column :answer_sessions, :encounter, :string
  end
end
