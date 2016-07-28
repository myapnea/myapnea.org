class AddCategoryToResearchTopics < ActiveRecord::Migration[4.2]
  def change
    add_column :research_topics, :category, :string, null: false, default: 'user_submitted'
  end
end
