class IoError < Log

  # Instance methods.

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
    case this.controller_name
    when "epiclc.varland.com"
      parts << "epiclc: <code>#{self.opto_data[:epiclc] ? "✔" : "✘"}</code>."
    end
    return parts.join(" ")
  end

  # Returns headers for CSV file.
  def csv_headers
    fields = ["Date/Time"]
    case this.controller_name
    when "epiclc.varland.com"
      fields << "epiclc"
    end
    return fields
  end

  # Returns data for CSV file.
  def to_csv
    fields = [self.log_at]
    case this.controller_name
    when "epiclc.varland.com"
      fields << self.opto_data[:epiclc]
    end
    return fields
  end

end