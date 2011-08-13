class MembersController < ApplicationController
  load_and_authorize_resource
  
  respond_to :html, :xml
  
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
    respond_with(members) do |format|
      format.json {render json: members.to_json}
    end
  end

  def show
    respond_with(member)
  end

  def new
    respond_with(member)
  end

  def edit
    respond_with(member)
  end

  def create
    flash[:notice] = 'Member was successfully created.' if member.save
    respond_with member, location: current_admin ? admin_console_path : member
  end

  def update
    if member.update_attributes(params[:member])
      flash[:notice] = 'Member was successfully updated.' 
    end
    respond_with member, location: admin_console_path
  end

  def destroy
    member.destroy
    flash[:notice] = 'Member was successfully deleted.'
    respond_with member, location: admin_console_path
  end
end
