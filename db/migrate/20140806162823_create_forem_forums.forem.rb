class CreateForemForums < ActiveRecord::Migration[4.2]
  def change
    create_table :forem_forums do |t|
      t.string :title
      t.text :description
    end
  end
end
