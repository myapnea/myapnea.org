class UpdateSurveyModels < ActiveRecord::Migration[4.2]
  def change
    add_column :surveys, :slug, :string
    add_column :questions, :display_type, :string
    add_column :answer_options, :text, :string
    add_column :answer_options, :hotkey, :string
    add_column :answer_options, :value, :integer
  end
end
