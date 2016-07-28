class CreateQuestionHelp < ActiveRecord::Migration[4.2]
  def change
    create_table :question_help_messages do |t|
      t.text :message_en
      t.text :message_s
      t.timestamps
    end
  end
end
