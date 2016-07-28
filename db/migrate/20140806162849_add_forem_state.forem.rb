class AddForemState < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :forem_state, :string, default: 'pending_review'
  end
end
