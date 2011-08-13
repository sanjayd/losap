class MembersController < ApplicationController
  load_and_authorize_resource
  
  expose(:month) do
    year = params[:year] || Date.today.year
    month = params[:month] || Date.today.month
    Date.parse("#{year}-#{month}-01")
  end

  expose(:members) do
    Member.all_like(URI.unescape(params[:term])) if params[:term]
  end

  expose(:member)
  
  def index
    respond_to do |format|
      format.html
      format.xml  { render :xml => members }
      format.json {render :json => members.to_json}
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => member }
    end
  end

  def new
    respond_to do |format|
      format.html
      format.xml  { render :xml => member }
    end
  end

  def edit
  end

  def create
    respond_to do |format|
      if member.save
        flash[:notice] = 'Member was successfully created.'
        format.html do
          if current_admin
            redirect_to(admin_console_path)
          else
            redirect_to(member)
          end
        end
        format.xml  { render :xml => member, :status => :created, :location => member }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => member.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if member.update_attributes(params[:member])
        flash[:notice] = 'Member was successfully updated.'
        format.html { redirect_to(admin_console_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => member.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    member.destroy

    respond_to do |format|
      flash[:notice] = 'Member was successfully deleted.'
      format.html { redirect_to(admin_console_path) }
      format.xml  { head :ok }
    end
  end
end
