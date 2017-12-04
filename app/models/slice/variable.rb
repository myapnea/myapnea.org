# frozen_string_literal: true

# Helps contain information about a question on a survey.
class Slice::Variable
  attr_accessor :json, :id, :name, :display_name, :description, :variable_type, :units,
                :prepend, :append, :field_note, :time_duration_format, :time_of_day_format,
                :show_current_button, :date_format, :domain_options, :show_seconds

  def initialize(json: {})
    load_from_json(json) if json.present?
    @domain_options ||= []
  end

  def load_from_json(json)
    return unless json
    @json = json
    root_attributes.each do |attribute|
      send("#{attribute}=", json[attribute.to_s])
    end
  end

  def root_attributes
    [
      :id, :name, :display_name, :description, :variable_type, :units, :prepend,
      :append, :field_note, :time_duration_format, :time_of_day_format,
      :show_current_button, :date_format, :show_seconds
    ]
  end
end
