class AddPreferredToNotAnswerFlagToAs < ActiveRecord::Migration[4.2]
  def change
    add_column :answers, :preferred_not_to_answer, :boolean, null: false, default: false
  end
end
