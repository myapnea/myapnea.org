class AddKeywordsToAdminResearchArticles < ActiveRecord::Migration
  def change
    add_column :admin_research_articles, :keywords, :string
  end
end
