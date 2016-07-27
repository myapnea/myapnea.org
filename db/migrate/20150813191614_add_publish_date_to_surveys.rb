class AddPublishDateToSurveys < ActiveRecord::Migration[4.2]
  def change
    add_column :surveys, :publish_date, :date
  end
end
