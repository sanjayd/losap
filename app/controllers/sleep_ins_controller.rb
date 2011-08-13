class SleepInsController < ApplicationController
  cache_sweeper :report_sweeper, :only => [:create, :update, :destroy]

  expose(:member)
  expose(:sleep_ins) {member.sleep_ins}
  expose(:sleep_in)

  def index
    respond_to do |format|
      format.xml {render :xml => sleep_ins}
    end
  end

  def new
    respond_to do |format|
      format.html
      format.xml {render :xml => sleep_in}
    end
  end

  def create
    respond_to do |format|
      if sleep_in.save
        flash[:notice] = 'Saved Sleep-In'
        format.html {redirect_to(member)}
        format.xml {render :xml => member, :status => :created, :location => member}
      else
        format.html {render :action => 'new'}
        format.xml {render :xml => sleep_in.errors, :status => :unprocessable_entity}
      end
    end
  end

  def update
    respond_to do |format|
      if sleep_in.update_attributes(params[:sleep_in])
        if sleep_in.deleted?
          flash[:notice] = 'Sleep-In Deleted'
        else
          flash[:notice] = 'Sleep-In Undeleted'
        end
        format.js
      else
        flash[:warning] = 'Undeleting this Sleep-In would conflict with a Standby'          
        format.js {head :unprocessable_entity}
      end
    end
  end

  def destroy
    sleep_in.destroy

    respond_to do |format|
      format.html {redirect_to(member)}
      format.xml {head :ok}
    end
  end
end
