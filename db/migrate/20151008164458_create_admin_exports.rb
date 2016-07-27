class CreateAdminExports < ActiveRecord::Migration[4.2]
  def change
    create_table :admin_exports do |t|
      t.string :file
      t.integer :user_id
      t.integer :total_steps, null: false, default: 0
      t.integer :current_step, null: false, default: 0
      t.string :status, null: false, default: 'started'
      t.datetime :file_created_at
      t.text :details

      t.timestamps null: false
    end

    add_index :admin_exports, :user_id
  end
end
