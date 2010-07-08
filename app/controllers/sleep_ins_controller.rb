class SleepInsController < ApplicationController
  before_filter :find_member, :except => :update

  def index
    @sleep_ins = @member.sleep_ins

    respond_to do |format|
      format.xml {render :xml => @sleep_ins}
    end
  end

  def new
    @sleep_in = @member.sleep_ins.build

    respond_to do |format|
      format.html
      format.xml {render :xml => @sleep_in}
    end
  end

  def create
    @sleep_in = @member.sleep_ins.build(params[:sleep_in])

    respond_to do |format|
      if @sleep_in.save
        flash[:notice] = 'Saved Sleep-In'
        format.html {redirect_to(@member)}
        format.xml {render :xml => @member, :status => :created, :location => @member}
      else
        format.html {render :action => 'new'}
        format.xml {render :xml => @sleep_in.errors, :status => :unprocessable_entity}
      end
    end
  end

  def update
    @sleep_in = SleepIn.find(params[:id])
    
    respond_to do |format|
      if @sleep_in.update_attributes(params[:sleep_in])
        if @sleep_in.deleted?
          flash[:notice] = 'Sleep-In Deleted'
        else
          flash[:notice] = 'Sleep-In Undeleted'
        end
        format.js {head :ok}
      else
        flash[:warning] = 'Undeleting this Sleep-In would conflict with a Standby'          
        format.js {head :ok}
      end
    end
  end

  def destroy
    @sleep_in = SleepIn.find(params[:id])
    @sleep_in.destroy

    respond_to do |format|
      format.html {redirect_to(@member)}
      format.xml {head :ok}
    end
  end

  private
  def find_member
    @member = Member.find(params[:member_id])
  end
end
