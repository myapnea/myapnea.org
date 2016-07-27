class AddStateToAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :answers, :state, :string, null: false, default: "unseen"
  end
end
