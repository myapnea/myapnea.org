class ChangeAnswerStateDefault < ActiveRecord::Migration
  def change
    change_column_default :answers, :state, "incomplete"
  end
end
