class DropQuestions < ActiveRecord::Migration[5.2]
  def change
    drop_table :questions do |t|
      t.text :text_en
      t.text :text_es
      t.integer :question_help_message_id
      t.decimal :time_estimate
      t.string :slug
      t.integer :user_id
      t.boolean :deleted, default: false, null: false
      t.boolean :archived, default: false, null: false
      t.timestamps
      t.index :slug
      t.index :user_id
    end
  end
end
