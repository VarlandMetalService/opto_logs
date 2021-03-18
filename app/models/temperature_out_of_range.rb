class TemperatureOutOfRange < Log

  # Instance methods.

  # Returns badge classes for log.
  def badge_classes
    return ["text-white", "bg-red-500"]
  end

  # Returns notification settings for log.
  def notification_settings
    return {
      enabled: true,
      subject: "Temperature Out of Range",
      recipients: [TOBY_VARLAND_SMS]
    }
  end

  # Default details string.
  def details
    return "Temperature is out of range. Low Limit: <code>#{self.low_limit}℉</code>. High Limit: <code>#{self.high_limit}℉</code>. Reading: <code>#{self.reading}℉</code>."
  end

  # Returns headers for CSV file.
  def csv_headers
    return ["Date/Time", "Low Limit (℉)", "High Limit (℉)", "Reading (℉)"]
  end

  # Returns data for CSV file.
  def to_csv
    attributes = %w{log_at low_limit high_limit reading}
    return attributes.map {|attr| self.send(attr) }
  end

end