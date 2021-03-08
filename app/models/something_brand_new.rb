class SomethingBrandNew < Log

  # Instance methods.

  # Returns badge classes for log.
  def badge_classes
    return ["text-blue-700", "bg-yellow-200"]
  end

  # Default details string.
  def details
    return "This is a test message. Limit: <code>#{self.limit}</code>. Reading: <code>#{self.reading}</code>."
  end

  # Returns headers for CSV file.
  def csv_headers
    return ["Date/Time", "Limit", "Reading"]
  end

  # Returns data for CSV file.
  def to_csv
    attributes = %w{log_at limit reading}
    return attributes.map {|attr| self.send(attr) }
  end

end