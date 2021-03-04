class LogsController < ApplicationController

  # Define filters available for has_scope gem.
  has_scope :sorted_by, only: :index
  has_scope :with_type, only: :index
  has_scope :with_controller, only: [:index, :live]
  has_scope :with_date_lte, only: :index
  has_scope :with_date_gte, only: :index

  # Log listing.
  def index
    params[:sorted_by] = 'newest' if params[:sorted_by].blank?
    respond_to do |format|
      format.html {
        @unpaged_logs = apply_scopes(Log.all)
        begin
          @pagy, @logs = pagy(@unpaged_logs, items: 100)
        rescue
          @pagy, @logs = pagy(@unpaged_logs, items: 100, page: 1)
        end
      }
      format.json {
        @logs = apply_scopes(Log.all)
      }
      format.csv {
        @logs = apply_scopes(Log.all)
        send_data @logs.to_csv, filename: "#{@logs[0].type}_#{DateTime.current.strftime("%Y%m%d_%H%M%S")}.csv"
      }
    end
  end

  # Live log listing.
  def live
    @logs = apply_scopes(Log.sorted_by("newest")).limit(20)
  end
  
end