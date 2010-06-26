class ReportsController < ApplicationController
  before_filter :require_admin

  def show
    @members = Member.all
    
    if params[:date] =~ /^\d{4}$/
      @year = params[:date]
    else
      @month = Date.parse(params[:date])
    end

    respond_to do |format|
      format.html {render :layout => "annual_report"}
      format.js {render :layout => false }
    end
  end
end
