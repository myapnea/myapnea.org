class AddCategoryToResearchTopics < ActiveRecord::Migration
  def change
    add_column :research_topics, :category, :string, null: false, default: "user_submitted"
  end
end
