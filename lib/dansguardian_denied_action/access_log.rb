require 'observer'
require 'timeout'
require 'filewatch/tail'

module DansguardianDeniedAction
  class AccessLog
    include Observable

    def initialize( format:, path: '/var/log/dansguardian/access.log', action: 'DENIED' )
      raise "Unsupported format: #{format}" unless SUPPORTED_FORMATS.include?( format )
      @format = format
      @path = path
      @action = action
      @log_class = LOG_CLASSES[format]
    end

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

    def tail_file
      file_watch = FileWatch::Tail.new
      file_watch.tail( "#{@path}*" )
      file_watch.subscribe do |_, line|
        process_line( line )
      end
    end

    def process_line( line )
      if line =~ /\*#{@action}\*/
        changed
        log = @log_class.new( line ) 
        notify_observers( log )
      end
    end

  end
end
