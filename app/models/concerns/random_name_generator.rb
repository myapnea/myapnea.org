# frozen_string_literal: true

# Generates random forum name
module RandomNameGenerator
  extend ActiveSupport::Concern

  included do
    def self.generate_forum_name(input, additional_seed = nil)
      input += additional_seed if additional_seed
      seed = Digest::MD5.hexdigest(input.to_s).hex.to_s
      adjective = adjectives[(seed[0..3].to_i % adjectives.size)]
      color = colors[(seed[4..7].to_i % colors.size)]
      animal = animals[(seed[8..11].to_i % animals.size)]
      "#{adjective}#{color}#{animal}#{seed[12..15]}"
    end

    def self.adjectives
      @adjectives ||= load_yaml('adjectives')
    end

    def self.colors
      @colors ||= load_yaml('colors')
    end

    def self.animals
      @animals ||= load_yaml('animals')
    end

    def self.load_yaml(name)
      YAML.load_file(Rails.root.join('lib', 'data', 'profiles', "#{name}.yml"))
    end
  end
end
