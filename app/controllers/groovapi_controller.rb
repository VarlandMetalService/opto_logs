class GroovapiController < ApplicationController

  skip_before_action  :verify_authenticity_token

  def log

    # Return error if log parameter not sent.
    return head(:internal_server_error) if params[:log].blank?

    # Parse JSON data from log parameter.
    json = JSON.parse(params[:log], symbolize_names: true)

    # Find log type.
    begin
      log_class = json[:type].camelize.constantize
    rescue NameError
      log_class = OptoLog
    end

    # Parse and save log object.
    log = log_class.parse(json)
    if log.save
      return head(:ok)
    else
      return head(:internal_server_error)
    end

  end

end