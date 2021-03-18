require 'json'
require 'csv'

class Log < ApplicationRecord

  # Validations.
  validates :controller_name,
            presence: true
  validates :log_at,
            presence: true
  validates :json_data,
            presence: true

  # Callbacks.
  after_create_commit :process_notification
  after_create_commit { LogBroadcastJob.perform_later self }

  # Scopes.
  scope :with_date_gte, ->(value) {
    return if value.blank?
    where("log_at >= ?", value)
  }
  scope :with_date_lte,  ->(value) {
    return if value.blank?
    where("log_at <= ?", value)
  }
  scope :with_controller, ->(value) {
    return if value.blank?
    where(controller_name: value.titleize)
  }
  scope :with_type, ->(value) {
    return if value.blank?
    where(type: value)
  }
  scope :sorted_by, ->(value) {
    return if value.blank?
    case value
    when 'newest'
      order(log_at: :desc)
    when 'oldest'
      order(:log_at)
    end
  }

  # Instance methods.

  # Returns badge classes for log. May be overridden in child class.
  def badge_classes
    return ["text-dark", "bg-light"]
  end

  # Returns notification settings for log. Should be overridden in child class.
  def notification_settings
    return {
      enabled: false,
      subject: nil,
      recipients: nil
    }
  end

  # Returns recipients for notification. Substitutes active foremen email for placeholder.
  def get_recipients
    recipients = self.notification_settings[:recipients]
    if recipients.include?(FOREMAN_EMAIL)
      recipients.delete(FOREMAN_EMAIL)
      addresses = JSON.parse(Net::HTTP.get(URI.parse(URI.escape("http://timeclock.varland.com/foremen_email.json"))))
      addresses.each do |email|
        recipients << email
      end
    end
    return recipients
  end

  # Sends notification email if configured.
  def process_notification
    if self.notification_settings[:enabled]
      OptoMailer.with(log: self).opto_notification.deliver_later
    end
  end

  # Returns human readable log type. May be overridden in child class for special cases.
  def log_type
    return Log.humanize_log_type(self.type)
  end

  # Default details string. Should be overridden in child class.
  def details
    return "<code>#{self.opto_data.to_s}</code>"
  end

  # Shortcut method for decoding and symbolizing stored JSON data.
  def opto_data
    return JSON.parse(self.json_data, symbolize_names: true)
  end

  # Returns headers for CSV file. Should be overridden in child class.
  def csv_headers
    return %w{log_at controller_name type details}
  end

  # Returns data for CSV file. Should be overridden in child class.
  def to_csv
    attributes = %w{log_at controller_name type details}
    return attributes.map {|attr| self.send(attr) }
  end

  # Parse attributes from JSON.
  def parse(json)
    self.controller_name = json[:controller]
    self.log_at = json[:timestamp].present? ? Time.zone.strptime(json[:timestamp], "%m/%d/%Y %H:%M:%S") : DateTime.current
    self.json_data = ::ActiveSupport::JSON.encode(json)
    [:lane, :station, :shop_order, :load, :barrel, :customer, :process, :part, :sub, :reading, :limit, :low_limit, :high_limit].each do |attr|
      self[attr] = json.fetch(attr, nil)
    end
  end

  # Example of how to extend in child class:
  #     def parse(json)
  #       super
  #       self.attribute = ...
  #       self.attribute = ...
  #       self.attribute = ...
  #     end

  # Updates log type and re-parses attributes from passed JSON.
  def update_type
    json = JSON.parse(self.json_data, symbolize_names: true)
    begin
      log_class = json[:type].camelize.constantize
      self.type = log_class.to_s
      self.save
      updated = Log.find(self.id)
      updated.parse(json)
      updated.save
    rescue
      return
    end
  end

  # Class methods.

  # Humanizes log type.
  def self.humanize_log_type(type)
    formatted = type.demodulize.titleize
    substitutions = [["Ph", "pH"], ["En", "EN"], ["Io", "I/O"]]
    substitutions.each do |sub|
      formatted.gsub!(sub[0], sub[1])
    end
    return formatted
  end

  # Get filter options for controller.
  def self.controller_options(with_controller, with_type)
    return [with_controller] unless with_controller.blank?
    return Log.with_type(with_type).distinct.pluck(:controller_name).sort
  end

  # Get filter options for type.
  def self.type_options(with_controller, with_type)
    raw = []
    if with_type.blank?
      raw = Log.with_controller(with_controller).distinct.pluck(:type)
    else
      raw << with_type
    end
    type_options = []
    raw.each do |type|
      type_options << [Log.humanize_log_type(type), type]
    end
    return type_options.sort
  end

  # Formats records for CSV file. Should be overridden in child class.
  def self.to_csv
    included_headers = false
    CSV.generate(headers: true) do |csv|
      all.each do |log|
        unless included_headers
          csv << log.csv_headers
          included_headers = true
        end
        csv << log.to_csv
      end
    end
  end

  # Parses log details from passed JSON.
  def self.parse(json)
    log = self.new
    log.parse(json)
    return log
  end

end