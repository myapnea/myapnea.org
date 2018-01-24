class CreateArticleVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :article_votes do |t|
      t.integer :article_id
      t.integer :user_id
      t.integer :rating, null: false, default: 0
      t.timestamps
      t.index [:article_id, :user_id], unique: true
    end
  end
end
