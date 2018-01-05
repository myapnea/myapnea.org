class AddSliceBaselineEventToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :slice_baseline_event, :string
  end
end
