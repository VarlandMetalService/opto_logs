class SaltSprayTemperatureWarning < Log

  # Instance methods.

  # Returns badge classes for log.
  def badge_classes
    return ["text-white", "bg-green-500"]
  end

  # Returns notification settings for log.
  def notification_settings
    return {
      enabled: true,
      subject: "#{self.controller_name}: Salt Spray Temperature Warning",
      recipients: [TOBY_VARLAND_EMAIL]
    }
  end

  # Default details string.
  def details
    return "Salt spray temperature is out of range. Low Limit: <code>#{self.low_limit}º F</code>. High Limit: <code>#{self.high_limit}º F</code>. Reading: <code>#{self.reading}º F</code>."
  end

  # Returns headers for CSV file.
  def csv_headers
    return ["Date/Time", "Low Limit (º F)", "High Limit (º F)", "Reading (º F)"]
  end

  # Returns data for CSV file.
  def to_csv
    attributes = %w{log_at low_limit high_limit reading}
    return attributes.map {|attr| self.send(attr) }
  end

end