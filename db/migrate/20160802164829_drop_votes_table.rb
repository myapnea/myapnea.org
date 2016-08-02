class DropVotesTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :votes do |t|
      t.integer :user_id
      t.integer :rating
      t.integer :research_topic_id
      t.string :label
      t.boolean :deleted, null: false, default: false
      t.timestamps
    end
  end
end
