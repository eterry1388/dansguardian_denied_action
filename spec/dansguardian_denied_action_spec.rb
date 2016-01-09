require 'spec_helper'

describe DansguardianDeniedAction do
  it 'has a version number' do
    expect( DansguardianDeniedAction::VERSION ).not_to be nil
  end

  sample_logs = {
    DansguardianDeniedAction::LOG_FORMAT_DANSGUARDIAN =>
      %q(),
    DansguardianDeniedAction::LOG_FORMAT_CSV =>
      %q("2016.1.8 19:46:10","fred","192.168.0.1","http://example.com","*DENIED* Banned site: example.com","GET","3804","0","pornography","1","403","text/html","fred.example.com","group-name","Mozilla/5.0"),
    DansguardianDeniedAction::LOG_FORMAT_SQUID =>
      %q(),
    DansguardianDeniedAction::LOG_FORMAT_TAB =>
      %q(),
    DansguardianDeniedAction::LOG_FORMAT_PROTEX =>
      %q(),
    DansguardianDeniedAction::LOG_FORMAT_PROTEX_BLANKED =>
      %q()
  }

  DansguardianDeniedAction::SUPPORTED_FORMATS.each do |format|
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
        its( :category )            { is_expected.to eq( 'pornography' ) }
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
