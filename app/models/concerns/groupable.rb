# frozen_string_literal: true

# This is included for compatibility to group aggregate functions in Postgresql 8.3

module Groupable
  extend ActiveSupport::Concern

  included do
    def self.columns_for_group
      column_names.collect { |cn| "#{table_name}.#{cn}" }.join(', ')
    end
  end
end
