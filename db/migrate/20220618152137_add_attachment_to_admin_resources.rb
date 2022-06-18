class AddAttachmentToAdminResources < ActiveRecord::Migration[6.1]
  def change
    add_column :admin_resources, :attachment, :string
    add_column :admin_resources, :attachment_name, :string
    add_column :admin_resources, :attachment_content_type, :string
    add_column :admin_resources, :attachment_byte_size, :bigint, default: 0, null: false
  end
end
