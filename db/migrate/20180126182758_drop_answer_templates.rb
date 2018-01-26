class DropAnswerTemplates < ActiveRecord::Migration[5.2]
  def change
    drop_table :answer_templates do |t|
      t.string :name
      t.integer :display_type_id
      t.integer :parent_answer_option_value
      t.string :text
      t.string :unit
      t.integer :user_id
      t.string :template_name
      t.integer :parent_answer_template_id
      t.boolean :archived, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.timestamps
      t.index :deleted
      t.index :parent_answer_template_id
      t.index :user_id
    end
  end
end
