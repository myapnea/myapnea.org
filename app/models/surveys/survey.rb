class Survey < ActiveRecord::Base
  # Constants
  SURVEY_DATA_LOCATION = ['lib', 'data', 'myapnea', 'surveys']

  # Concerns
  include Localizable
  include TSort

  # Translations
  localize :name
  localize :description
  localize :short_description

  # Authorization
  include Authority::Abilities
  self.authorizer_name = "OwnerAuthorizer"


  # Associations
  belongs_to :first_question, class_name: "Question"
  has_many :answer_sessions, -> { where deleted: false }
  has_many :question_edges, dependent: :delete_all
  has_many :survey_question_orders, -> { order "question_number asc" }
  has_many :ordered_questions, through: :survey_question_orders, foreign_key: "question_id", class_name: "Question", source: :question
  has_many :survey_answer_frequencies

  # Named scopes
  scope :viewable, -> { where(status: "show") }

  # Class Methods
  def self.complete(user)
    res = joins(:answer_sessions).where(status: "show", answer_sessions: {user_id: user.id, deleted: false}).select do |qf|
      as = qf.answer_sessions.where(user_id: user.id, deleted: false).order(updated_at: :desc).first


      as.present? and as.completed? and !as.deleted?
    end

    res
  end

  def self.unstarted(user)
    user_id = (user.present? ? user.id : nil)
    res = includes(:answer_sessions).where(status: "show").select{ |qf| user_id.blank? or qf.answer_sessions.where(user_id: user.id, deleted: false).empty? }

    res
  end

  def self.incomplete(user)
    res = joins(:answer_sessions).where(status: "show", answer_sessions: {user_id: user.id, deleted: false}).select do |qf|
      as = qf.answer_sessions.where(user_id: user.id).order(updated_at: :desc).first

      as.present? and !as.completed? and !as.deleted?
    end
    res
  end

  def self.refresh_all_surveys
    Survey.all.each do |survey|
      survey.refresh_precomputations
    end
  end

  def self.load_from_file(name)
    ## CREATES A NEW SURVEY

    data_file = YAML.load_file(Rails.root.join(*(SURVEY_DATA_LOCATION + ["#{name}.yml"])))

    # Find or Create Survey
    survey = Survey.find_by_slug(data_file["slug"])
    if survey.blank?
      survey = Survey.create(name_en: data_file["name"], slug: data_file["slug"], description_en: data_file["description"], status: data_file["status"])
    else
      survey.update_attributes(name_en: data_file["name"], slug: data_file["slug"], description_en: data_file["description"], status: data_file["status"], first_question_id: nil)
      QuestionEdge.destroy_all(survey_id: survey.id)
    end

    latest_question = nil

    data_file["questions"].each do |question_attributes|
      question = Question.find_by_slug(question_attributes["slug"])
      if question.blank?
        question = Question.create(text_en: question_attributes["text"], display_type: question_attributes["display_type"], slug: question_attributes["slug"])
      else
        question.update_attributes(text_en: question_attributes["text"], display_type: question_attributes["display_type"], slug: question_attributes["slug"])
      end

      question_attributes["answer_templates"].each do |answer_template_attributes|
        answer_template = AnswerTemplate.find_by_name(answer_template_attributes["name"])
        if answer_template.blank?
          answer_template = AnswerTemplate.create(name: answer_template_attributes["name"], data_type: answer_template_attributes["data_type"], display_type_id: answer_template_attributes["display_type_id"], allow_multiple: answer_template_attributes["allow_multiple"].present?)
        else
          answer_template.update_attributes(name: answer_template_attributes["name"], data_type: answer_template_attributes["data_type"], display_type_id: answer_template_attributes["display_type_id"], allow_multiple: answer_template_attributes["allow_multiple"].present?)
        end

        if answer_template_attributes.has_key?("answer_options")
          answer_template_attributes["answer_options"].each do |answer_option_attributes|
            answer_option = answer_template.answer_options.find_by_value(answer_option_attributes["value"])

            if answer_option.blank?
              answer_template.answer_options.create(text: answer_option_attributes["text"], hotkey: answer_option_attributes["hotkey"], value: answer_option_attributes["value"])
            else
              answer_option.update_attributes(text: answer_option_attributes["text"], hotkey: answer_option_attributes["hotkey"], value: answer_option_attributes["value"])
            end

          end
        end

        question.answer_templates << answer_template
      end


      survey.first_question_id = question.id if survey.first_question_id.blank?

      if latest_question.present?
        qe = QuestionEdge.build_edge(latest_question, question, nil, survey.id)

        puts("Creating edge between #{latest_question.id} and #{question.id}")

        raise StandardError, qe.errors.full_messages unless qe.save
      end
      latest_question = question
    end

    survey.save
    survey.refresh_precomputations
  end

  ## Need to be fast
  def complete?(user)
    false unless user.present?
    answer_session = self.answer_sessions.where( user_id: user.id ).order( updated_at: :desc ).first
    answer_session.present? and answer_session.completed?
  end

  def incomplete?(user)
    false unless user.present?
    answer_session = self.answer_sessions.where( user_id: user.id ).order( updated_at: :desc ).first
    answer_session.present? and !answer_session.completed?
  end

  def unstarted?(user)
    false unless user.present?
    self.answer_sessions.where( user_id: user.id ).empty?
  end

  ## Needed for topographic sort, which is not very fast
  def tsort_each_node(&block)
    all_questions_descendants.each(&block)
  end

  def tsort_each_child(node, &block)
    node.children.each(&block)
  end

  def completion_percent(user)
    if self.unstarted?(user)
      0
    elsif self.complete?(user)
      100
    else
      self.most_recent_answer_session(user).percent_completed
    end
  end

  ## Cached in database, need to be refreshed on change (when questions are updated!!)
  # TODO: Put in survey rake task

  # TODO: Rename - it's not tsorted edges but tsorted questions (nodes)
  def tsorted_question_ids
    if self[:tsored_nodes].blank?

      update_attribute(:tsorted_nodes, tsort.reverse.map(&:id).to_json)


    end

    JSON::parse(self[:tsorted_nodes])
  end

  def total_time
    ActiveSupport::Deprecation.warn("Time estimates disabled until they are further developed.")
    nil
    # if self[:longest_time].blank?
    #   lp = 0
    #
    #   leaves.each do |oneleaf|
    #     lp = [lp, find_longest_path(source,oneleaf)[:time]].max
    #   end
    #
    #
    #   update_attribute(:longest_time, lp)
    #
    #
    #
    # end
    #
    # self[:longest_time]
  end

  # Alias
  def total_questions
    longest_path_length
  end

  def longest_path_length
    path_length(source)
    #
    # if self[:longest_path].blank?
    #   ld = 0
    #
    #   leaves.each do |oneleaf|
    #     ld = [ld, find_longest_path(source,oneleaf)[:distance]].max
    #   end
    #
    #   update_attribute(:longest_path, ld)
    # end
    #
    # self[:longest_path]
  end

  def path_length(current_question)
    survey_question_orders.where(question_id: current_question.id).first.remaining_distance
  end

  ## Cache ordering in database and allow quick lookup of questions. Need to be run on reload!!
  # TODO: Put in survey rake task
  def refresh_precomputations
    # tsort nodes
    update_attribute(:tsorted_nodes, nil)
    tsorted_question_ids

    # survey_question_order
    load_survey_question_order
  end


  def load_survey_question_order
    survey_question_orders.destroy_all

    tsort.reverse.each_with_index do |question, order|

      SurveyQuestionOrder.create(question_id: question.id, survey_id: self.id, question_number: order + 1, remaining_distance: find_longest_path_length_to_leaf(question) )

    end
  end


  # Instance methods
  def most_recent_answer_session(user)
    answer_sessions.where(user_id: user.id).order(updated_at: :desc).first
  end

  ## WORK IN PROGRESS
  def completion_stats(user)
    most_recent_answer_session(user).calculate_status_stats
  end




  ###

  # Efficient lookup of questions (1 query), returns relation
  def all_questions

    Question
        .distinct
        .joins('left join question_edges parent_qe on parent_qe.child_question_id = "questions".id')
        .joins('left join question_edges child_qe on child_qe.parent_question_id = "questions".id')
        .where("child_qe.survey_id = ? or child_qe.survey_id is null", self.id)
        .where("parent_qe.survey_id = ? or parent_qe.survey_id is null", self.id)
        .where("parent_qe.child_question_id is not null or child_qe.parent_question_id is not null")
        .where("parent_qe.direct = 't' and child_qe.direct = 't'")
  end

  # Fast (uses descendant cache?), returns array
  def all_questions_descendants
    # source .descendants is very fast with no db hits! why? How can we use it? It's type is ActiveRecord::Association::CollectionProxy
    ([source] + source.descendants)
  end

  # Alias
  def source
    first_question
  end

  # private

  # Should only be called when precomputing
  def find_leaf
    if first_question.descendants.length > 0
      leaves = first_question.descendants.select {|q| q.leaf?}

      raise StandardError, "Multiple leaves found!" if leaves.length > 1
      raise StandardError, "No leaf found!" if leaves.length == 0

      leaves.first
    else
      # Only one question!
      first_question
    end

  end

  def find_leaves
    if first_question.descendants.length > 0
      first_question.descendants.select {|q| q.leaf?}


    else
      # Only one question!
      [first_question]
    end

  end

  ### Used in calculating remaining path.
  def find_longest_path_length_to_leaf(source)
    longest = 0

    find_leaves.each do |a_leaf|
      begin
        temp_result = find_longest_path_length(source,a_leaf)
      rescue
        temp_result = 0
      end

      longest = [longest, temp_result].max if temp_result
    end

    longest
  end

  def find_longest_path_length(source, destination)
    # Cached
    topological_order = tsorted_question_ids[tsorted_question_ids.find_index(source.id)..tsorted_question_ids.find_index(destination.id)]


    # Set to -Inifinity
    distances = Hash[topological_order.map {|q| [q,-1*Float::INFINITY]}]

    distances[source.id] = 1

    topological_order.each do |question_id|
      question = Question.find(question_id)

      question.children.each do |child|

        eq_test = distances[child.id] < distances[question.id] + 1

        if eq_test
          distances[child.id] = distances[question.id] + 1
        end
      end
    end

    distances[destination.id]
  end

end
