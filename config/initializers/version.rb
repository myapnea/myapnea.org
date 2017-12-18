# frozen_string_literal: true

module WwwMyapneaOrg
  module VERSION #:nodoc:
    MAJOR = 15
    MINOR = 1
    TINY = 2
    BUILD = "pre" # "pre", "beta1", "beta2", "rc", "rc2", nil

    STRING = [MAJOR, MINOR, TINY, BUILD].compact.join(".").freeze
  end
end
