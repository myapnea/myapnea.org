class RemovePublishDateFromSurveys < ActiveRecord::Migration[4.2]
  def change
    remove_column :surveys, :publish_date, :date
  end
end
