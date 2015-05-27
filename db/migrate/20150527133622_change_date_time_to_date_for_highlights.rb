class ChangeDateTimeToDateForHighlights < ActiveRecord::Migration
  def up
    change_column :highlights, :display_date, :date
  end

  def down
    change_column :highlights, :display_date, :datetime
  end
end
