class AddSlugToAnswerOptions < ActiveRecord::Migration
  def change
    add_column :answer_options, :slug, :string

    add_index :answer_options, :slug
  end
end
