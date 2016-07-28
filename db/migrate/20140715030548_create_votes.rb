class CreateVotes < ActiveRecord::Migration[4.2]
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.integer :question_id
      t.integer :rating
      t.timestamps
    end
  end
end
