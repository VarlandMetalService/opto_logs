class OptoMailer < ApplicationMailer

  # Load Opto helpers.
  helper :opto

  # Default warning notification email.
  def opto_notification
    return if params[:log].blank?
    @log = params[:log]
    mail  to:       @log.get_recipients,
          subject:  "#{@log.notification_settings[:subject]} (#{DateTime.current.strftime("%m/%d/%y %l:%M%P")})"
  end

end