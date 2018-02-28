# frozen_string_literal: true

# Tracks a series of designs filled out on an event date for a subject.
class Slice::SubjectEvent
  attr_accessor :json, :id, :name, :event, :event_designs, :percent, :unblinded_responses_count, :unblinded_questions_count

  def initialize(json)
    @json = json
    @id = json["id"]
    @name = json["name"]
    @event = json["event"]
    @unblinded_percent = json["unblinded_percent"]
    @unblinded_responses_count = json["unblinded_responses_count"]
    @unblinded_questions_count = json["unblinded_questions_count"]
    @event_designs = load_event_designs(json["event_designs"])
  end

  def percent
    @unblinded_percent
  end

  def load_event_designs(json_event_designs)
    if json_event_designs
      json_event_designs.collect do |json|
        Slice::EventDesign.new(json, self)
      end
    else
      []
    end
  end

  def sheets_where(sheet_id)
    @event_designs.collect { |ed| ed.sheets_where(sheet_id) }.flatten
  end

  def complete?(subject)
    event_designs.count { |ed| ed.incomplete?(subject) }.zero?
  end
end
