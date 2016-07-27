class AddVersionToSurveys < ActiveRecord::Migration[4.2]
  def change
    add_column :surveys, :version, :string
  end
end
