class TempAuxAirPressureLow < Log

  # Instance methods.

  # Returns badge classes for log.
  def badge_classes
    return ["text-white", "bg-yellow-500"]
  end

  # Returns notification settings for log.
  def notification_settings
    return {
      enabled: true,
      subject: "#{self.controller_name}: Auxiliary Air Pressure Low",
      recipients: [TOBY_VARLAND_EMAIL, BRIAN_MANGOLD_EMAIL, JOEL_PERRINE_EMAIL, RICH_BRANSON_SMS, TED_MCKEEHAN_SMS, TOBY_VARLAND_SMS]
    }
  end

  # Default details string.
  def details
    return "Auxiliary air pressure low. Limit: <code>#{self.limit} PSI</code>. Reading: <code>#{self.reading} PSI</code>. Groov turned on the Quincy 50HP compressor."
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