class AddPublishDateToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :publish_date, :date
  end
end
