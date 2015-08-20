## DEPRECATED IN 8.0

class Report < ActiveRecord::Base
  belongs_to :answer_value
  belongs_to :answer_option
  belongs_to :answer_template
  belongs_to :answer
  belongs_to :question
  belongs_to :answer_session
  belongs_to :user
  belongs_to :survey

  def self.frequency_data(question_slug, values=nil, users=nil)

    q = Question.where(slug: question_slug).includes(answer_templates: :answer_options).first
    answer_options = q.answer_templates.first.answer_options


    base_query = Report.where(question_slug: question_slug)
    base_query = base_query.where(value: values.map(&:to_s)) if values.present?
    base_query = base_query.where(user: users.map(&:to_s)) if users.present?

    total_count = base_query.count

    ao_counts = base_query.select("survey_slug, question_slug, answer_template_name,answer_option_id,value,max(answer_option_text) as answer_option_text,count(answer_value_id) as answer_count").group('survey_slug,question_slug,answer_template_name,value,answer_option_id').map(&:attributes)


    final_counts = answer_options.map do |ao|
      ao_count = ao_counts.select{|ac| ac["answer_option_id"] == ao.id}.first
      ac = ao_count.present? ? ao_count["answer_count"] : 0

      [ao.value, {text: ao.text, count: ac, freq: (ac.to_f/total_count.to_f)*100.0}]
    end

    Hash[final_counts]
  end

end
