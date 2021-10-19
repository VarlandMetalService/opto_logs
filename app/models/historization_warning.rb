class HistorizationWarning < Log

  # Instance methods.

  # Returns badge classes for log.
  def badge_classes
    return ["text-white", "bg-yellow-500"]
  end

  # Returns notification settings for log.
  def notification_settings
    return {
      enabled: true,
      subject: "#{self.controller_name}: Historization Warning",
      recipients: [TOBY_VARLAND_EMAIL]
    }
  end

  # Default details string.
  def details
    return "Historization not working. Limit: <code>#{self.limit} seconds</code>. Reading: <code>#{self.reading} seconds</code>."
  end

  # Returns headers for CSV file.
  def csv_headers
    return ["Date/Time", "Limit (sec)", "Reading (sec)"]
  end

  # Returns data for CSV file.
  def to_csv
    attributes = %w{log_at limit reading}
    return attributes.map {|attr| self.send(attr) }
  end

end