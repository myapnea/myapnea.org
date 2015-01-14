class QuestionFlow < ActiveRecord::Base
  # Concerns
  include Localizable
  include TSort

  localize :name
  localize :description
  localize :short_description

  include Authority::Abilities
  self.authorizer_name = "OwnerAuthorizer"


  # Associations
  belongs_to :first_question, class_name: "Question"
  has_many :answer_sessions, -> { where deleted: false }
  has_many :question_edges
  has_many :survey_question_orders, -> { order "question_number asc" }
  has_many :ordered_questions, through: :survey_question_orders, foreign_key: "question_id", class_name: "Question", source: :question
  has_many :survey_answer_frequencies

  scope :viewable, -> { where(status: "show") }

  # Class Methods
  def self.complete(user)
    res = joins(:answer_sessions).where(status: "show", answer_sessions: {user_id: user.id}).select do |qf|
      as = qf.answer_sessions.where(user_id: user.id).order(updated_at: :desc).first


      as.present? and as.completed?
    end

    res
  end

  def self.unstarted(user)
    user_id = (user.present? ? user.id : nil)
    res = includes(:answer_sessions).where(status: "show").select{ |qf| user_id.blank? or qf.answer_sessions.where(user_id: user.id).empty? }

    res
  end

  def self.incomplete(user)
    res = joins(:answer_sessions).where(status: "show", answer_sessions: {user_id: user.id}).select do |qf|
      as = qf.answer_sessions.where(user_id: user.id).order(updated_at: :desc).first

      as.present? and !as.completed?
    end
    res
  end

  def self.refresh_all_question_flows
    QuestionFlow.all.each do |qf|
      qf.refresh_precomputations
    end
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

      SurveyQuestionOrder.create(question_id: question.id, question_flow_id: self.id, question_number: order + 1, remaining_distance: find_longest_path_length_to_leaf(question) )

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
        .where("child_qe.question_flow_id = ? or child_qe.question_flow_id is null", self.id)
        .where("parent_qe.question_flow_id = ? or parent_qe.question_flow_id is null", self.id)
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
