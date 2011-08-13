class ReportsController < ApplicationController
  load_and_authorize_resource
  
  expose(:report) {Report.new(params[:date])}

  def show
    respond_to do |format|
      if report.annual?
        format.html {render :layout => "annual_report",
                      :template => "reports/annual/show"}
      elsif report.monthly?
        format.js {render :layout => false, 
                      :template => "reports/monthly/show" }
      end
    end
  end
end
