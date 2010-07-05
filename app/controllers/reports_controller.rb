class ReportsController < ApplicationController
  before_filter :require_admin

  def show
    @report = Report.new(params[:date])

    respond_to do |format|
      if @report.annual?
        format.html {render :layout => "annual_report",
                      :template => "reports/annual/show"}
      elsif @report.monthly?
        format.js {render :layout => false, 
                      :template => "reports/monthly/show" }
      end
    end
  end
end
