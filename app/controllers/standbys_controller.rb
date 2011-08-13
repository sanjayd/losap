class StandbysController < ApplicationController
  cache_sweeper :report_sweeper, :only => [:create, :update, :destroy]

  respond_to :html, :xml, :js

  expose(:member)
  expose(:standbys) {member.standbys}
  expose(:standby)

  def index
    respond_with standbys
  end

  def new
    respond_with standby
  end

  def create
    if standby.save
      if standby.points > 0
        flash[:notice] = 'Saved Standby'
      else
        flash[:warning] = 'Standby was saved, but is worth 0 LOSAP points'
      end
    end
    respond_with standby, location: member
  end

  def update
    if standby.update_attributes(params[:standby])
      if standby.deleted?
        flash[:notice] = 'Standby Deleted'
      else
        flash[:notice] = 'Standby Undeleted'
      end
    else
      flash[:warning] = 'Undeleting this Standby would conflict with a Sleep-In'
    end
    respond_with standby
  end

  def destroy
    standby.destroy
    respond_with standby, location: member
  end
end
