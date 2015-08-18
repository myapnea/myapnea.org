class RemovePublishDateFromSurveys < ActiveRecord::Migration
  def change
    remove_column :surveys, :publish_date, :date
  end
end
