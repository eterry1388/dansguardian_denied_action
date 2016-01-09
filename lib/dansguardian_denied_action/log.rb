module DansguardianDeniedAction
  class Log
    attr_reader :raw, :date_time, :requesting_user, :requesting_ip, :requested_url,
                :actions, :reason, :subreason, :method, :size, :weight, :category,
                :filter_group_number, :http_code, :mime_type, :client_name,
                :filter_group_name, :user_agent

    def initialize( raw )
      @raw = raw
    end
  end
end
