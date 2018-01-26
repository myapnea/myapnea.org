class DropQuestionHelpMessage < ActiveRecord::Migration[5.2]
  def change
    drop_table :question_help_messages do |t|
      t.text :message_en
      t.text :message_s
      t.timestamps
    end
  end
end
