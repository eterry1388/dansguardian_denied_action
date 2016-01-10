require 'dansguardian_denied_action/log'
require 'csv'

module DansguardianDeniedAction

  # Represents a single log line in the access logs with the CSV (2) log file format
  class CsvLog < Log

    # @param raw [String] Raw log line string that will be parsed
    def initialize( raw )
      super

      begin
        @parsed = raw.parse_csv
      rescue CSV::MalformedCSVError
        return
      end

      @date_time           = @parsed[0]
      @requesting_user     = @parsed[1]
      @requesting_ip       = @parsed[2]
      @requested_url       = @parsed[3]
      action_reason        = @parsed[4].try( :split, '*' ).try( :reject!, &:empty? ).try( :map!, &:strip )
      if action_reason
        @actions           = action_reason.first # TODO: This is not getting all the actions, but only the first!
        @reason            = action_reason.last
        @subreason         = action_reason.last # TODO: What should the subreason be?
      end
      @method              = @parsed[5]
      @size                = @parsed[6].to_i
      @weight              = @parsed[7].to_i
      @category            = @parsed[8]
      @filter_group_number = @parsed[9].to_i
      @http_code           = @parsed[10].to_i
      @mime_type           = @parsed[11]
      @client_name         = @parsed[12]
      @filter_group_name   = @parsed[13]
      @user_agent          = @parsed[14]
    end
  end

end
