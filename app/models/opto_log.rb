class OptoLog < Log

  # Instance methods.

  # Returns notification settings for log.
  def notification_settings
    return {
      enabled: false,
      subject: "🔴 Unconfigured Opto Log Recorded",
      recipients: [IT_ONLY_EMAIL]
    }
  end

  # Returns human readable log type.
  def log_type
    "Unconfigured Opto Log"
  end

end