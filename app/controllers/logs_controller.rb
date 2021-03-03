class LogsController < ApplicationController

  # Log listing.
  def index
    @logs = Log.all
  end
  
end