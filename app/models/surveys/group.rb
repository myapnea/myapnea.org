class Group < ActiveRecord::Base
  has_many :questions

  def self.research_question_group
    Group.find_by_name("Research Questions")
  end

end
