class RemoveDeprecatedColumnsFromResearchTopics < ActiveRecord::Migration
  def change
    remove_column :research_topics, :text_deprecated
    remove_column :research_topics, :description_deprecated
    remove_column :research_topics, :state_deprecated
  end
end
