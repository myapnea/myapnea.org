class MakeForemViewsPolymorphic < ActiveRecord::Migration[4.2]
  def change
    rename_column :forem_views, :topic_id, :viewable_id
    add_column :forem_views, :viewable_type, :string
  end
end
