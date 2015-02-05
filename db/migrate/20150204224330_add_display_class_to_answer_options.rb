class AddDisplayClassToAnswerOptions < ActiveRecord::Migration
  def change
    add_column :answer_options, :display_class, :string
  end
end
