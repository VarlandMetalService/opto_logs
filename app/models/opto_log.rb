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

  # Class methods.

  # Update type of all unconfigured logs whenever possible.
  def self.fix_unconfigured
    OptoLog.all.each do |log|
      log.update_type
    end
  end

end