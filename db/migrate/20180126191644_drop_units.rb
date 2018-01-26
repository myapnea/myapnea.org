class DropUnits < ActiveRecord::Migration[5.2]
  def change
    drop_table :units do |t|
      t.string :name_en
      t.string :name_es
      t.timestamps
    end
  end
end
