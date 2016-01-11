require 'dansguardian_denied_action/access_log'
require 'dansguardian_denied_action/logs/dansguardian_log'
require 'dansguardian_denied_action/logs/csv_log'
require 'dansguardian_denied_action/logs/squid_log'
require 'dansguardian_denied_action/logs/tab_log'
require 'dansguardian_denied_action/logs/protex_log'
require 'dansguardian_denied_action/logs/protex_blanked_log'
require 'dansguardian_denied_action/constants'

# Dansguardian Denied Action. Triggers a custom action when a site is
# blocked/denied. Works by monitoring the access log of Dansguardian
# or e2guardian.
#
# @author {mailto:eterry1388@aol.com Eric Terry}
# @see https://github.com/eterry1388/dansguardian_denied_action
module DansguardianDeniedAction
end
