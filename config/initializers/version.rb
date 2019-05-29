# frozen_string_literal: true

module Myapnea
  module VERSION #:nodoc:
    MAJOR = 24
    MINOR = 0
    TINY = 1
    BUILD = "pre" # "pre", "beta1", "beta2", "rc", "rc2", nil

    STRING = [MAJOR, MINOR, TINY, BUILD].compact.join(".").freeze
  end
end
