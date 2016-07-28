class ChangeAnswerStateDefault < ActiveRecord::Migration[4.2]
  def change
    change_column_default :answers, :state, from: 'unseen', to: 'incomplete'
  end
end
