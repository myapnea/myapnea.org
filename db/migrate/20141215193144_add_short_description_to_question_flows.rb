class AddShortDescriptionToQuestionFlows < ActiveRecord::Migration
  def change
    add_column :question_flows, :short_description_en, :string
    add_column :question_flows, :short_description_es, :string
  end
end
