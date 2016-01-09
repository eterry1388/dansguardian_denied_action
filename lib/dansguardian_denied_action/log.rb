module DansguardianDeniedAction

  # Represents a single log line in the access logs
  #
  # @note Documentation about attribute accessors of this class was taken
  #  from http://contentfilter.futuragts.com/wiki/doku.php?id=the_access.log_files
  # @see http://contentfilter.futuragts.com/wiki/doku.php?id=the_access.log_files
  class Log

    # @return [String] Raw log line string that will be parsed
    attr_reader :raw

    # @return [String]
    attr_reader :date_time

    # @return [String] Requesting user or computer. If an "authplugin" has not
    #  identified a user or computer, this will return just a dash.
    attr_reader :requesting_user

    # @return [String] Requesting IP address. Watch out for DHCP networks where
    #  computers sometimes change IP addresses.
    attr_reader :requesting_ip

    # @return [String] Complete requested URL. Often much of this is hidden from the
    #  user.  Typically includes search terms.
    attr_reader :requested_url

    # @return [String] Items like *URLMOD*, *CONTENTMOD*, *SCANNED*, *INFECTED*, ending with
    #  either *DENIED* or *EXCEPTED* (*URLMOD* means urlregexplist tweaked the outgoing request,
    #  often used to force "safesearch" on) (*CONTENTMOD* means contentregexplist tweaked
    #  the incoming content, sometimes used to replace ofensive words with less offensive
    #  ones [but its use probably interferes with downloads, thus precluding them])
    attr_reader :actions

    # @return [String] An elaboration on the action
    attr_reader :reason

    # @return [String] More details about the action, for example the actual regular expressions
    attr_reader :subreason

    # @return [String] The HTTP request verb, usually either GET or POST (or HEAD)
    attr_reader :method

    # @return [Integer] The size in bytes of document (if it was fetched)
    attr_reader :size

    # @return [Integer] The sum of all the weighted phrase scores, which is the calculated
    #  naughtyness value
    attr_reader :weight

    # @return [String] Contents of the #listcategory tag (if any) in the list that's most
    #  relevant to the action
    attr_reader :category

    # @return [Integer] The filter group (1 => f1, 2 => f2, etc). the request was assigned to
    attr_reader :filter_group_number

    # @return [Integer] Always a three digit number, usually 200 if everything went okay
    attr_reader :http_code

    # @return [String] The MIME type of the document according to the website, usually
    #  "text/html" for webpages
    attr_reader :mime_type

    # @return [String] If configured, the result of performing a reverse DNS IP lookup on
    #  the requestor's IP address. Highly network dependent, meaningful on only some networks.
    attr_reader :client_name

    # @return [String] A more convenient presentation of the same information in filter group
    #  number. Only present if "groupname = ..." is specified in each dansguardianfN.conf file.
    attr_reader :filter_group_name

    # @return [String] Sometimes interesting and useful information. Note though that because
    #  this is so easily spoofed, it should not be used for any sort of security.
    attr_reader :user_agent

    # @param raw [String] Raw log line string that will be parsed
    def initialize( raw )
      @raw = raw
    end
  end
end
