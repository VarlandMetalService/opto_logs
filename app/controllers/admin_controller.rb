class AdminController < ApplicationController

  def reset_sidekiq_stats
    Sidekiq::Stats.new.reset
    redirect_back fallback_location: root_url
  end

end
