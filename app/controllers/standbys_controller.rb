class StandbysController < ApplicationController
  before_filter :find_member

  def index
    @standbys = @member.standbys

    respond_to do |format|
      format.xml {render :xml => @standbys}
    end
  end

  def new
    @standby = Standby.new
    @standby.member = @member
    
    respond_to do |format|
      format.html
      format.xml {render :xml => @standby}
    end
  end

  def create
    @standby = Standby.new(params[:standby])
    @standby.member = @member

    respond_to do |format|
      if @standby.save
        if @standby.points > 0
          flash[:notice] = 'Saved Standby'
        else
          flash[:warning] = 'Standby was saved, but is worth 0 LOSAP points'
        end
        format.html {redirect_to(@member)}
        format.xml {render :xml => @member, :status => :created, :location => @member}
      else
        format.html {render :action => 'new'}
        format.xml {render :xml => @standby.errors, :status => :unprocessable_entity}
      end
    end
  end

  def update
    @standby = Standby.find(params[:id])
    
    respond_to do |format|
      if @standby.update_attributes(params[:standby])
        if @standby.deleted?
          flash[:notice] = 'Standby Deleted'
        else
          flash[:notice] = 'Standby Undeleted'
        end
        format.js {head :ok}
      else
        flash[:warning] = 'Undeleting this Standby would conflict with a Sleep-In'
        format.js {head :ok}
      end
    end
  end

  def destroy
    @standby = Standby.find(params[:id])
    @standby.destroy

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
