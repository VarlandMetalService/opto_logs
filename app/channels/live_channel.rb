class LiveChannel < ApplicationCable::Channel

  def subscribed
    stream_from "live_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

end