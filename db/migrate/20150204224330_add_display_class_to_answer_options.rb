class AddDisplayClassToAnswerOptions < ActiveRecord::Migration[4.2]
  def change
    add_column :answer_options, :display_class, :string
  end
end
