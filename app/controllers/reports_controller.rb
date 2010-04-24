class ReportsController < ApplicationController
  def show
    @members = Member.all
    @month = get_month

    render :content_type => 'text/plain'
  end
end
