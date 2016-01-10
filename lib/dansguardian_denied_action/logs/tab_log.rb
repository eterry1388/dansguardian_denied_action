require 'dansguardian_denied_action/log'

module DansguardianDeniedAction

  # Represents a single log line in the access logs with the Tab delimited (4) log file format
  class TabLog < Log

    # @param raw [String] Raw log line string that will be parsed
    def initialize( raw )
      super
    end
  end
end
