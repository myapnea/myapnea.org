class AddResearchTopicIdToAdminResearchArticle < ActiveRecord::Migration[4.2]
  def change
    add_column :admin_research_articles, :research_topic_id, :integer

    add_index :admin_research_articles, :research_topic_id
  end
end
