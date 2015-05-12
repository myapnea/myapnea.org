class AddTypeToResearchTopics < ActiveRecord::Migration
  def change
    add_column :research_topics, :type, :string, null: false, default: "user_submitted"
  end
end
