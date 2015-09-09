class RemoveDeletedFromAnswersAndAnswerValues < ActiveRecord::Migration
  def up
    timestamp = '20150909151513'
    execute "drop view cdm_demographic"
    execute "drop view cdm_vital"
    execute "drop view cdm_enrollment"
    execute "drop view cdm_pro_cm"
    execute "drop view cdm_encounter"
    execute "drop view reports"
    execute view_sql(timestamp, :reports)
    remove_index :answers, [:answer_session_id, :question_id, :deleted]
    remove_index :answers, :deleted
    remove_column :answers, :deleted
    remove_column :answer_values, :deleted
  end

  def down
    add_column :answer_values, :deleted, :boolean, null: false, default: false
    add_column :answers, :deleted, :boolean, null: false, default: false
    add_index :answers, :deleted
    add_index :answers, [:answer_session_id, :question_id, :deleted], unique: true
    timestamp = '20150811192707'
    execute "drop view reports"
    execute view_sql(timestamp, :reports)

    timestamp = '20150515171427'
    execute view_sql(timestamp, :cdm_demographic)
    execute view_sql(timestamp, :cdm_vital)
    execute view_sql(timestamp, :cdm_enrollment)
    execute view_sql(timestamp, :cdm_encounter)
    execute view_sql(timestamp, :cdm_pro_cm)
  end
end
