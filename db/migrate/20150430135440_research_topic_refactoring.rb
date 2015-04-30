class ResearchTopicRefactoring < ActiveRecord::Migration
  def change
    # Research Topic
    add_column :research_topics, :progress, :string
    add_column :research_topics, :topic_id, :reference

    # Vote
    remove_column :comment_id, :integer
    remove_column :question_id, :integer
    remove_column :notification_id, :integer


  end
end
