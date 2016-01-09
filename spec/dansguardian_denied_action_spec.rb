require 'spec_helper'

describe DansguardianDeniedAction do
  sample_logs = {
    DansguardianDeniedAction::LOG_FORMAT_DANSGUARDIAN =>
      %q(),
    DansguardianDeniedAction::LOG_FORMAT_CSV =>
      %q("2016.1.8 19:46:10","fred","192.168.0.1","http://example.com","*DENIED* Banned site: example.com","GET","3804","0","Pornography","1","403","text/html","fred.example.com","group-name","Mozilla/5.0"),
    DansguardianDeniedAction::LOG_FORMAT_SQUID =>
      %q(),
    DansguardianDeniedAction::LOG_FORMAT_TAB =>
      %q(),
    DansguardianDeniedAction::LOG_FORMAT_PROTEX =>
      %q(),
    DansguardianDeniedAction::LOG_FORMAT_PROTEX_BLANKED =>
      %q()
  }

  # Dynamically loop through all supported formats
  DansguardianDeniedAction::SUPPORTED_FORMATS.each do |format|

    describe DansguardianDeniedAction::AccessLog do
      it 'Updates observer for every new log' do

        # Create fake access log
        fake_log = '/tmp/dansguardian_denied_action/access.log'
        FileUtils.mkdir_p( fake_log.split( '/' )[0..2].join( '/' ) )
        File.write( fake_log, '' )

        # Observer class that outputs to stdout
        class OutputToScreen
          def update( log )
            puts "IP: #{log.requesting_ip}, URL: #{log.requested_url}, Category: #{log.category}"
          end
        end

        access_log = DansguardianDeniedAction::AccessLog.new( format: format, path: fake_log )
        access_log.add_observer( OutputToScreen.new )

        monitor_thread = Thread.new { access_log.monitor( timeout: 4 ) }
        sleep 2 # Give a chance for the thread to start

        # Append sample log to fake dansguardian log file
        `echo '#{sample_logs[format]}' >> #{fake_log}`

        expect { monitor_thread.join }.to output(
          "IP: 192.168.0.1, URL: http://example.com, Category: Pornography\n"
        ).to_stdout
      end
    end

    describe 'logs' do
      log_class = DansguardianDeniedAction::LOG_CLASSES[format]

      describe log_class do
        let( :raw_log ) { sample_logs[format] }
        subject { log_class.new( raw_log ) }

        its( :raw )                 { is_expected.to eq( raw_log ) }
        its( :date_time )           { is_expected.to eq( '2016.1.8 19:46:10' ) }
        its( :requesting_user )     { is_expected.to eq( 'fred' ) }
        its( :requesting_ip )       { is_expected.to eq( '192.168.0.1' ) }
        its( :requested_url )       { is_expected.to eq( 'http://example.com' ) }
        its( :actions )             { is_expected.to eq( 'DENIED' ) }
        its( :reason )              { is_expected.to eq( 'Banned site: example.com' ) }
        its( :subreason )           { is_expected.to eq( 'Banned site: example.com' ) }
        its( :method )              { is_expected.to eq( 'GET' ) }
        its( :size )                { is_expected.to eq(  3804 ) }
        its( :weight )              { is_expected.to eq( 0 ) }
        its( :category )            { is_expected.to eq( 'Pornography' ) }
        its( :filter_group_number ) { is_expected.to eq( 1 ) }
        its( :http_code )           { is_expected.to eq( 403 ) }
        its( :mime_type )           { is_expected.to eq( 'text/html' ) }
        its( :client_name )         { is_expected.to eq( 'fred.example.com' ) }
        its( :filter_group_name )   { is_expected.to eq( 'group-name' ) }
        its( :user_agent )          { is_expected.to eq( 'Mozilla/5.0' ) }
      end
    end
  end
end
