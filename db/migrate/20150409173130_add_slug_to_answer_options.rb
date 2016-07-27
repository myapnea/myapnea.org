class AddSlugToAnswerOptions < ActiveRecord::Migration[4.2]
  def change
    add_column :answer_options, :slug, :string

    add_index :answer_options, :slug
  end
end
