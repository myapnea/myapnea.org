class RemoveBetaOptInFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :beta_opt_in, :boolean, null: false, default: false
  end
end
