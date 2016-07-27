class AddEncountersToAnswerSession < ActiveRecord::Migration[4.2]
  def change
    add_column :answer_sessions, :encounter, :string
  end
end
