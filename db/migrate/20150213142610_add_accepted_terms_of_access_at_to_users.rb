class AddAcceptedTermsOfAccessAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :accepted_terms_of_access_at, :datetime
  end
end
