class LogsController < ApplicationController

  # Log listing.
  def index
    respond_to do |format|
      format.html {
        @unpaged_logs = Log.all
        begin
          @pagy, @logs = pagy(@unpaged_logs, items: 100)
        rescue
          @pagy, @logs = pagy(@unpaged_logs, items: 100, page: 1)
        end
      }
      format.json {
        @logs = Log.all
      }
      format.csv {
        @logs = Log.all
        send_data @logs.to_csv, filename: "#{@logs[0].type}_#{DateTime.current.strftime("%Y%m%d_%H%M%S")}.csv"
      }
    end
  end
  
end