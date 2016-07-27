class AddBetaOptInToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :beta_opt_in, :boolean, null: false, default: false
  end
end
