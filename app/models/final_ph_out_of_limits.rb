class FinalPhOutOfLimits < Log

  # Instance methods.

  # Returns notification settings for log.
  def notification_settings
    return {
      enabled: false,
      subject: "Waste Water: Final pH Out of Limits",
      recipients: [TOBY_VARLAND_EMAIL, TOBY_VARLAND_SMS]
    }
  end

  # Default details string.
  def details
    return "Final pH Out of Limits:<br><br>Low Limit: <code>#{self.low_limit}</code><br>High Limit: <code>#{self.high_limit}</code><br>Reading: <code>#{self.reading}</code>"
  end

end