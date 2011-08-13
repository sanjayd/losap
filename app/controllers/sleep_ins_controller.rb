class SleepInsController < ApplicationController
  cache_sweeper :report_sweeper, :only => [:create, :update, :destroy]

  respond_to :html, :xml, :js

  expose(:member)
  expose(:sleep_ins) {member.sleep_ins}
  expose(:sleep_in)

  def index
    respond_with sleep_ins
  end

  def new
    respond_with sleep_in
  end

  def create
    if sleep_in.save
      flash[:notice] = 'Saved Sleep-In'
    end
    respond_with sleep_in, location: member
  end

  def update
    if sleep_in.update_attributes(params[:sleep_in])
      if sleep_in.deleted?
        flash[:notice] = 'Sleep-In Deleted'
      else
        flash[:notice] = 'Sleep-In Undeleted'
      end
    else
      flash[:warning] = 'Undeleting this Sleep-In would conflict with a Standby'          
    end
    respond_with sleep_in
  end

  def destroy
    sleep_in.destroy
    respond_with sleep_in, location: member
  end
end
