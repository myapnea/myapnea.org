# frozen_string_literal: true

# Helps contain information about a survey.
class Slice::Section
  attr_accessor :json, :id, :name, :description, :level

  def initialize(json: {})
    load_from_json(json) if json.present?
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
      :id,
      :name,
      :description,
      :level
    ]
  end
end
