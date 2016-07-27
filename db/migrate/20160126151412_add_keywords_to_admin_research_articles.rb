class AddKeywordsToAdminResearchArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :admin_research_articles, :keywords, :string
  end
end
