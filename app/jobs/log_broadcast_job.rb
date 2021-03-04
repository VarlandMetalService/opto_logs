class LogBroadcastJob < ApplicationJob

  queue_as :default

  def perform(log)
    ActionCable.server.broadcast "live_channel", log: render_log(log), controller: log.controller_name
  end

  private

    def render_log(log)
      ApplicationController.renderer.render(partial: "logs/log", locals: { log: log })
    end

end