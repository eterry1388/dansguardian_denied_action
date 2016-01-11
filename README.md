# Dansguardian Denied Action

[![Gem Version](https://badge.fury.io/rb/dansguardian_denied_action.svg)](https://badge.fury.io/rb/dansguardian_denied_action)
[![Inline docs](http://inch-ci.org/github/eterry1388/dansguardian_denied_action.svg?branch=master)](http://inch-ci.org/github/eterry1388/dansguardian_denied_action)

Triggers a custom action when a site is blocked/denied. Works by monitoring the access log of Dansguardian or e2guardian.

[DansGuardian](http://dansguardian.org) is an award winning Open Source web content filter. It filters the actual content of pages based on many methods including phrase matching, PICS filtering and URL filtering. It does not purely filter based on a banned list of sites like lesser totally commercial filters.

[e2guardian](http://e2guardian.org) is a fork of Dansguardian Project with many improvements and bug fixes, e2guardian is a web content filtering proxy that works in conjunction with another caching proxy such as Squid.

## Installation

```bash
gem install dansguardian_denied_action
```

## Usage

`dansguardian_denied_action` follows the Observer pattern.  See more information from the [Ruby Rdocs](http://ruby-doc.org/stdlib-2.1.0/libdoc/observer/rdoc/Observable.html).  You can add as many observers as you'd like that are triggered when a denied action log is added to the access log.  An observer is an instance of a class that has an `update` method defined.  The `update` method is called whenever the observer is notified (when there is a denied log).

Currently only log file format 2 (CSV-style format) is supported.  Please contribute if you'd like more formats supported.  Make sure your `/etc/dansguardian/dansguardian.conf` has the `logfileformat` set as `2`.  For example:

```bash
# Log File Format
# 1 = DansGuardian format (space delimited)
# 2 = CSV-style format
# 3 = Squid Log File Format
# 4 = Tab delimited
# 5 = Protex format
# 6 = Protex format with server field blanked

logfileformat = 2
```

### Example

```ruby
require 'dansguardian_denied_action'

# An observer class that outputs to the screen
class OutputToScreen
  def update( log )
    puts "IP:       #{log.requesting_ip}"
    puts "URL:      #{log.requested_url}"
    puts "Category: #{log.category}"
  end
end

# An observer class that sends an email
class SendEmail
  def update( log )
    message = "Denied page accessed!\n\n"
    message << "IP:       #{log.requesting_ip}\n"
    message << "URL:      #{log.requested_url}\n"
    message << "Category: #{log.category}"
    `echo "#{message}" | mail -s "Denied page" admin@example.com`
  end
end

# Initialize the access log class and select the format of dansguardian
@access_log = DansguardianDeniedAction::AccessLog.new( format: DansguardianDeniedAction::LOG_FORMAT_CSV )

# Add as many observers as you'd like
@access_log.add_observer( OutputToScreen.new )
@access_log.add_observer( SendEmail.new )

# Call the monitor method to monitor the log and notify
# your observers when a blocked page is accessed
@access_log.monitor
```

## Customization

If you want to trigger your observers on an action other than `DENIED`, you can specify one like so:

```ruby
@access_log = DansguardianDeniedAction::AccessLog.new(
  format: DansguardianDeniedAction::LOG_FORMAT_CSV,
  action: 'INFECTED'
)
```

### e2guardian

If you are using e2guardian rather than dansguardian, you want to point to the correct log path.  For example:

```ruby
@access_log = DansguardianDeniedAction::AccessLog.new(
  format: DansguardianDeniedAction::LOG_FORMAT_CSV,
  path: '/var/log/e2guardian/access.log'
)
```

## Log methods

Your observer class which as the `update` method defined accepts a `log` as it's sole argument.  This is an instance of `DansguardianDeniedAction::Log`.  The accessor methods available include:

* raw
* date_time
* requesting_user
* requesting_ip
* requested_url
* actions
* reason
* subreason
* method
* size
* weight
* category
* filter_group_number
* http_code
* mime_type
* client_name
* filter_group_name
* user_agent

More information on the data within these accessor methods can be found on the [DansGuardian Documentation Wiki](http://contentfilter.futuragts.com/wiki/doku.php?id=the_access.log_files).

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
