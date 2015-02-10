class AddStateToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :state, :string, null: false, default: "unseen"
  end
end
