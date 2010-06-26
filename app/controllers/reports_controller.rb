class ReportsController < ApplicationController
  before_filter :require_admin

  def show
    @members = Member.all
    @month = Date.parse(params[:month])

    respond_to do |format|
      format.js {render :layout => false }
    end
  end
end
