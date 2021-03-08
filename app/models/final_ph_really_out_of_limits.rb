class FinalPhReallyOutOfLimits < Log

  # Instance methods.

  # Parse attributes from JSON.
  def parse(json)
    super
    self.limit = json[:low_limit] + json[:high_limit]
  end

  # Returns badge classes for log.
  def badge_classes
    return ["text-white", "bg-purple-500"]
  end

  # Returns notification settings for log.
  def notification_settings
    return {
      enabled: true,
      subject: "Waste Water: Final pH Really Out of Limits",
      recipients: [TOBY_VARLAND_SMS]
    }
  end

  # Default details string.
  def details
    return "Final pH is really out of limits. Limit: <code>#{self.limit}</code>. Low Limit: <code>#{self.low_limit}</code>. High Limit: <code>#{self.high_limit}</code>. Reading: <code>#{self.reading}</code>."
  end

  # Returns headers for CSV file.
  def csv_headers
    return ["Date/Time", "pH Limit", "Low pH Limit", "High pH Limit", "pH Reading"]
  end

  # Returns data for CSV file.
  def to_csv
    attributes = %w{log_at limit low_limit high_limit reading}
    return attributes.map {|attr| self.send(attr) }
  end

end