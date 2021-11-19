class ChartRuntimeError < Log

  # Instance methods.

  # Returns badge classes for log.
  def badge_classes
    return ["text-white", "bg-pink-500"]
  end

  # Returns notification settings for log.
  def notification_settings
    return {
      enabled: true,
      subject: "#{self.controller_name}: Chart Runtime Error",
      recipients: [TOBY_VARLAND_EMAIL]
    }
  end

  # Define function to return chart name.
  def chart
    return self.opto_data[:device]
  end

  # Default details string.
  def details
    return "Chart running too long. Chart: <code>#{self.chart}</code>. Limit: <code>#{self.limit} seconds</code>. Runtime: <code>#{self.reading} seconds</code>."
  end

  # Returns headers for CSV file.
  def csv_headers
    return ["Date/Time", "Chart", "Limit (sec)", "Runtime (sec)"]
  end

  # Returns data for CSV file.
  def to_csv
    attributes = %w{log_at chart limit reading}
    return attributes.map {|attr| self.send(attr) }
  end

end