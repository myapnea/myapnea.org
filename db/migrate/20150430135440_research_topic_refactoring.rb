class ResearchTopicRefactoring < ActiveRecord::Migration[4.2]
  def change
    # Research Topic
    add_column :research_topics, :progress, :string
    add_column :research_topics, :topic_id, :integer
    add_index :research_topics, :topic_id

    # Vote
    remove_column :votes, :comment_id, :integer
    remove_column :votes,  :question_id, :integer
    remove_column :votes,  :notification_id, :integer


  end
end
