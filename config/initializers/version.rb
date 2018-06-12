# frozen_string_literal: true

module Myapnea
  module VERSION #:nodoc:
    MAJOR = 17
    MINOR = 5
    TINY = 2
    BUILD = nil # "pre", "beta1", "beta2", "rc", "rc2", nil

    STRING = [MAJOR, MINOR, TINY, BUILD].compact.join(".").freeze
  end
end
