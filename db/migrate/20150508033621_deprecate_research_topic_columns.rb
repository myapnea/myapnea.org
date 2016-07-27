class DeprecateResearchTopicColumns < ActiveRecord::Migration[4.2]
  def change
    rename_column :research_topics, :text, :text_deprecated
    rename_column :research_topics, :description, :description_deprecated
    rename_column :research_topics, :state, :state_deprecated
  end
end
