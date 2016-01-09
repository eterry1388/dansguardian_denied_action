require 'observer'
require 'timeout'
require 'filewatch/tail'

module DansguardianDeniedAction

  # Main interface to the gem
  class AccessLog
    include Observable

    # @param format [Integer] The log file format specified on the "logfileformat" property
    #  in /etc/dansguardian/dansguardian.conf. Options include:  1 = Dansguardian format
    #  (space delimited), 2 = CSV-style format, 3 = Squid Log File Format, 4 = Tab delimited,
    #  5 = Protex format, 6 = Protex format with server field blanked.
    # @param path [String] File path to access.log
    # @param action [String] Action string to trigger notifications of observers
    # @raise [ArgumentError] if an unsupported format is passed in
    # @note Only format 2 is currently supported!
    def initialize( format:, path: '/var/log/dansguardian/access.log', action: 'DENIED' )
      raise ArgumentError, "Unsupported format: #{format}" unless SUPPORTED_FORMATS.include?( format )
      @format = format
      @path = path
      @action = action
      @log_class = LOG_CLASSES[format]
    end

    # Monitors the access.log by tailing the file watching for blocked pages accessed
    #
    # @param timeout [Integer, NilClass] Specify a timeout for monitoring the access
    #  logs.  If not specified, it will monitor the logs indefinitely.
    def monitor( timeout: nil )
      if timeout
        begin
          Timeout::timeout( timeout ) { tail_file }
        rescue Timeout::Error
          # Do nothing
        end
      else
        tail_file
      end
    end

    private

    # Tail the log files
    def tail_file
      file_watch = FileWatch::Tail.new
      file_watch.tail( "#{@path}*" )
      file_watch.subscribe do |_, line|
        process_line( line )
      end
    end

    # Notifies the observers if a line in the log matches the action
    #
    # @param line [String] Log line
    def process_line( line )
      if line =~ /\*#{@action}\*/
        changed
        log = @log_class.new( line ) 
        notify_observers( log )
      end
    end

  end
end
