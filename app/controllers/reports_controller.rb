class ReportsController < ApplicationController
  before_filter :require_admin

  def show
    @members = Member.all
    
    if params[:date] =~ /^\d{4}$/
      @year = Date.parse("#{params[:date]}-01-01")
    else
      @month = Date.parse(params[:date])
    end

    respond_to do |format|
      if @year
        format.html {render :layout => "annual_report",
                      :template => "reports/annual/show"}
      elsif @month
        format.js {render :layout => false, 
                      :template => "reports/monthly/show" }
      end
    end
  end
end
