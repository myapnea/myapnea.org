class ChangeAdminPartnerIdToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :admin_partners, :id, :bigint
  end

  def down
    change_column :admin_partners, :id, :integer
  end
end
