require 'dansguardian_denied_action/log'

module DansguardianDeniedAction

  # Represents a single log line in the access logs with the Squid (3) log file format
  class SquidLog < Log

    # @param raw [String] Raw log line string that will be parsed
    def initialize( raw )
      super
    end
  end
end
