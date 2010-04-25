class SleepInsController < ApplicationController
  before_filter :find_member

  def index
    @sleep_ins = @member.sleep_ins

    respond_to do |format|
      format.xml {render :xml => @sleep_ins}
    end
  end

  def new
    @sleep_in = SleepIn.new
    @sleep_in.member = @member

    respond_to do |format|
      format.html
      format.xml {render :xml => @sleep_in}
    end
  end

  def create
    @sleep_in = SleepIn.new(params[:sleep_in])
    @sleep_in.member = @member

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
        format.js {head :ok}
      else
        format.js {head :unprocessable_entity}
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