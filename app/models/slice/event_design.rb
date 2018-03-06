# frozen_string_literal: true

# Tracks a series of events on a design.
class Slice::EventDesign
  attr_accessor :subject_event, :json, :sheets, :design_id, :design_name, :event_id

  def initialize(json, subject_event)
    @subject_event = subject_event
    @json = json
    @design_id = json.dig("design", "id")
    @design_name = json.dig("design", "name")
    @event_id = json.dig("event", "id")
    @sheets = load_sheets(json["sheets"])
  end

  def valid?
    @event_id.present? && @design_id.present? && @design_name.present?
  end

  def complete?(subject)
    subject.subject_surveys.find_by(event: @event_id, design: @design_id)&.completed?
  end

  def incomplete?(subject)
    !complete?(subject)
  end

  def percent
    @sheets.first ? @sheets.first.percent : 0
  end

  def sheets_where(sheet_id)
    @sheets.select { |s| s.id.to_i == sheet_id.to_i }
  end

  private

  def load_sheets(json_sheets)
    if json_sheets
      json_sheets.collect do |json|
        Slice::Sheet.new(json)
      end
    else
      []
    end
  end
end
