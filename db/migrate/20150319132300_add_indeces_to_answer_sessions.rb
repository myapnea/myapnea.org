class AddIndecesToAnswerSessions < ActiveRecord::Migration[4.2]
  def change
    add_index :answers, :answer_session_id
    add_index :answers, :question_id
    add_index :answer_values, :answer_id
    add_index :answer_values, :answer_option_id
    add_index :answer_values, :answer_template_id
    add_index :answer_templates_questions, :question_id
    add_index :answer_templates_questions, :answer_template_id
    add_index :answr_options_answer_templates, :answer_option_id
    add_index :answr_options_answer_templates, :answer_template_id
    add_index :surveys, :first_question_id
    add_index :answer_sessions, :user_id
    add_index :answer_sessions, :survey_id
    add_index :answer_sessions, :last_answer_id
    add_index :answer_sessions, :first_answer_id


  end
end
