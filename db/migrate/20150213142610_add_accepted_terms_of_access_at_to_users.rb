class AddAcceptedTermsOfAccessAtToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :accepted_terms_of_access_at, :datetime
  end
end
