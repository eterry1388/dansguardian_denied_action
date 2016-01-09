# Dansguardian Denied Actiont

[![Gem Version](https://badge.fury.io/rb/dansguardian_denied_action.svg)](https://badge.fury.io/rb/dansguardian_denied_action)

Triggers a custom action when a site is blocked/denied.  Works by monitoring the access log of Dansguardian or e2guardian.

[DansGuardian](http://dansguardian.org) is an award winning Open Source web content filter. It filters the actual content of pages based on many methods including phrase matching, PICS filtering and URL filtering. It does not purely filter based on a banned list of sites like lesser totally commercial filters.

[e2guardian](http://e2guardian.org) is a fork of Dansguardian Project with many improvements and bug fixes, e2guardian is a web content filtering proxy that works in conjunction with another caching proxy such as Squid.

## Installation

```bash
gem install dansguardian_denied_action
```

## Usage

```ruby
require 'dansguardian_denied_action'

class OutputToScreen
  def update( log )
    puts "IP:       #{log.requesting_ip}"
    puts "URL:      #{log.requested_url}"
    puts "Category: #{log.category}"
  end
end

class SendEmail
  def update( log )
    message = "Denied page accessed!\n\n"
    message << "IP:       #{log.requesting_ip}\n"
    message << "URL:      #{log.requested_url}\n"
    message << "Category: #{log.category}"
    `echo "#{message}" | mail -s "Denied page" admin@example.com`
  end
end

@access_log = DansguardianDeniedAction::AccessLog.new( format: DansguardianDeniedAction::LOG_FORMAT_CSV )
@access_log.add_observer( OutputToScreen.new )
@access_log.add_observer( SendEmail.new )
@access_log.monitor
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eterry1388/dansguardian_denied_action.  Please make sure
all tests pass before making a pull request.  The tests require an OS with a `/tmp` directory.

### How to run system tests

```bash
rspec
```

The output should look something like this:

```
DansguardianDeniedAction
  DansguardianDeniedAction::AccessLog
    Updates observer for every new log
  logs
    DansguardianDeniedAction::CsvLog
      raw
        should eq "\"2016.1.8 19:46:10\",\"fred\",\"192.168.0.1\",\"http://example.com\",\"*DENIED* Banned site: example.com\",\"GET\",\"3804\",\"0\",\"Pornography\",\"1\",\"403\",\"text/html\",\"fred.example.com\",\"group-name\",\"Mozilla/5.0\""
      date_time
        should eq "2016.1.8 19:46:10"
      requesting_user
        should eq "fred"
      requesting_ip
        should eq "192.168.0.1"
      requested_url
        should eq "http://example.com"
      actions
        should eq "DENIED"
      reason
        should eq "Banned site: example.com"
      subreason
        should eq "Banned site: example.com"
      method
        should eq "GET"
      size
        should eq 3804
      weight
        should eq 0
      category
        should eq "Pornography"
      filter_group_number
        should eq 1
      http_code
        should eq 403
      mime_type
        should eq "text/html"
      client_name
        should eq "fred.example.com"
      filter_group_name
        should eq "group-name"
      user_agent
        should eq "Mozilla/5.0"

Finished in 4.03 seconds (files took 0.10009 seconds to load)
19 examples, 0 failures
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
