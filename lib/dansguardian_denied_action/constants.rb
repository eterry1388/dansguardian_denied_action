module DansguardianDeniedAction
  LOG_FORMAT_DANSGUARDIAN   = 1
  LOG_FORMAT_CSV            = 2
  LOG_FORMAT_SQUID          = 3
  LOG_FORMAT_TAB            = 4
  LOG_FORMAT_PROTEX         = 5
  LOG_FORMAT_PROTEX_BLANKED = 6

  SUPPORTED_FORMATS = [
    LOG_FORMAT_CSV
  ]

  LOG_CLASSES = {
    LOG_FORMAT_DANSGUARDIAN   => DansguardianLog,
    LOG_FORMAT_CSV            => CsvLog,
    LOG_FORMAT_SQUID          => SquidLog,
    LOG_FORMAT_TAB            => TabLog,
    LOG_FORMAT_PROTEX         => ProtexLog,
    LOG_FORMAT_PROTEX_BLANKED => ProtexBlankedLog
  }
end
