class AnotherNewLog < Log

  # Instance methods.

  # Returns badge classes for log.
  def badge_classes
    return ["text-blue-700", "bg-yellow-200"]
  end

  # Default details string.
  def details
    return "This is a test message. High Limit: <code>#{self.high_limit}</code>. Reading: <code>#{self.reading}</code>."
  end

  # Returns headers for CSV file.
  def csv_headers
    return ["Date/Time", "High Limit", "Reading"]
  end

  # Returns data for CSV file.
  def to_csv
    attributes = %w{log_at high_limit reading}
    return attributes.map {|attr| self.send(attr) }
  end

end