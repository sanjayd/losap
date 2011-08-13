class StandbysController < ApplicationController
  cache_sweeper :report_sweeper, :only => [:create, :update, :destroy]

  expose(:member)
  expose(:standbys) {member.standbys}
  expose(:standby)

  def index
    respond_to do |format|
      format.xml {render :xml => standbys}
    end
  end

  def new
    respond_to do |format|
      format.html
      format.xml {render :xml => standby}
    end
  end

  def create
    respond_to do |format|
      if standby.save
        if standby.points > 0
          flash[:notice] = 'Saved Standby'
        else
          flash[:warning] = 'Standby was saved, but is worth 0 LOSAP points'
        end
        format.html {redirect_to(member)}
        format.xml {render :xml => member, :status => :created, :location => member}
      else
        format.html {render :action => 'new'}
        format.xml {render :xml => standby.errors, :status => :unprocessable_entity}
      end
    end
  end

  def update
    respond_to do |format|
      if standby.update_attributes(params[:standby])
        if standby.deleted?
          flash[:notice] = 'Standby Deleted'
        else
          flash[:notice] = 'Standby Undeleted'
        end
        format.js
      else
        flash[:warning] = 'Undeleting this Standby would conflict with a Sleep-In'
        format.js {head :unprocessable_entity}
      end
    end
  end

  def destroy
    standby.destroy

    respond_to do |format|
      format.html {redirect_to(member)}
      format.xml {head :ok}
    end
  end
end
