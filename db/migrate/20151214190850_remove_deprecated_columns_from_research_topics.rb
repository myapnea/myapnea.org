class RemoveDeprecatedColumnsFromResearchTopics < ActiveRecord::Migration[4.2]
  def change
    remove_column :research_topics, :text_deprecated, :string
    remove_column :research_topics, :description_deprecated, :text
    remove_column :research_topics, :state_deprecated, :string, null: false, default: 'under_review'
  end
end
