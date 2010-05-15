class ReportsController < ApplicationController
  def show
    @members = Member.all
    @month = get_month

    respond_to do |format|
      format.js {render :layout => false }
    end
  end
end
