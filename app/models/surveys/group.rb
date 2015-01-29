class Group < ActiveRecord::Base
  has_many :questions

  def self.research_question_group
    Group.find_by_name("Research Questions")
  end

  def minimum_set(survey, start_point = nil)
    current_q = start_point

    # go to start of group
    if start_point.present?

      while current_q.default_previous_question(survey).present? and current_q.default_previous_question(survey).group == self
        current_q = current_q.default_previous_question(survey)
      end
    else
      current_q = questions.select {|q| !q.ancestors.map(&:group).include? self }.first
    end

    min_set = [current_q]

    while (current_q = current_q.default_next_question(survey)) and current_q.present? and current_q.group == self
      min_set << current_q

    end



    min_set
  end




end