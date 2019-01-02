# frozen_string_literal: true

module Myapnea
  module VERSION #:nodoc:
    MAJOR = 21
    MINOR = 1
    TINY = 0
    BUILD = nil # "pre", "beta1", "beta2", "rc", "rc2", nil

    STRING = [MAJOR, MINOR, TINY, BUILD].compact.join(".").freeze
  end
end
