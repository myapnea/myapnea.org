class ChangeDateTimeToDateForHighlights < ActiveRecord::Migration[4.2]
  def up
    change_column :highlights, :display_date, :date
  end

  def down
    change_column :highlights, :display_date, :datetime
  end
end
