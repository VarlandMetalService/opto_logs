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
  after_create  :process_notification

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
    where(controller_name: value)
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
    type = self.type.demodulize.titleize
    substitutions = [["Ph", "pH"], ["En", "EN"]]
    substitutions.each do |sub|
      type.gsub!(sub[0], sub[1])
    end
    return type
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

  # Class methods.

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
    new_log = self.new
    new_log.controller_name = json[:controller]
    new_log.log_at = json[:timestamp].present? ? Time.zone.parse(json[:timestamp]) : DateTime.current
    new_log.json_data = ::ActiveSupport::JSON.encode(json)
    [:lane, :station, :shop_order, :load, :barrel, :customer, :process, :part, :sub, :reading, :limit, :low_limit, :high_limit].each do |attr|
      new_log[attr] = json.fetch(attr, nil)
    end
    return new_log
  end

  # Example of how to extend in child class:
  #     def self.parse(controller, json)
  #       new_log = super
  #       new_log.attribute = ...
  #       new_log.attribute = ...
  #       new_log.attribute = ...
  #       return new_log
  #     end

end