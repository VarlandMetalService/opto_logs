class IoError < Log

  # Instance methods.

  def bricks
    return self.opto_data.except(:type, :controller, :timestamp)
  end

  # Returns badge classes for log.
  def badge_classes
    return ["text-white", "bg-gray-700"]
  end

  # Returns notification settings for log.
  def notification_settings
    return {
      enabled: true,
      subject: "#{self.controller_name}: IO Error",
      recipients: [TOBY_VARLAND_EMAIL]
    }
  end

  # Default details string.
  def details
    parts = ["I/O error on one or more bricks."]
    self.bricks.each_with_index {|(name, enabled), index|
      parts << "#{name.to_s}: <code>#{enabled ? "✔" : "✘"}</code>."
    }
    return parts.join(" ")
  end

  # Returns headers for CSV file.
  def csv_headers
    return ["Date/Time", "Controller", "Data"]
  end

  # Returns data for CSV file.
  def to_csv
    attributes = %w{log_at controller_name opto_data}
    return attributes.map {|attr| self.send(attr) }
  end

end