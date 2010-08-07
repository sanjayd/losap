class MembersController < ApplicationController
  load_and_authorize_resource

  # GET /members
  # GET /members.xml
  def index
    if params[:term]
      @members = Member.all_like(URI.unescape(params[:term]))
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @members }
      format.js {render :json => @members.to_json}
    end
  end

  # GET /members/1
  # GET /members/1.xml
  def show
    @member = Member.find(params[:id])
    @month = get_month

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @member }
    end
  end

  # GET /members/new
  # GET /members/new.xml
  def new
    @member = Member.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @member }
    end
  end

  # GET /members/1/edit
  def edit
    @member = Member.find(params[:id])
  end

  # POST /members
  # POST /members.xml
  def create
    @member = Member.new(params[:member])

    respond_to do |format|
      if @member.save
        flash[:notice] = 'Member was successfully created.'
        format.html do
          if current_admin
            redirect_to(admin_console_path)
          else
            redirect_to(@member)
          end
        end
        format.xml  { render :xml => @member, :status => :created, :location => @member }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /members/1
  # PUT /members/1.xml
  def update
    @member = Member.find(params[:id])

    respond_to do |format|
      if @member.update_attributes(params[:member])
        flash[:notice] = 'Member was successfully updated.'
        format.html { redirect_to(admin_console_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.xml
  def destroy
    @member = Member.find(params[:id])
    @member.destroy

    respond_to do |format|
      flash[:notice] = 'Member was successfully deleted.'
      format.html { redirect_to(admin_console_path) }
      format.xml  { head :ok }
    end
  end

  private
  def get_month
    year = params[:year] || Date.today.year
    month = params[:month] || Date.today.month
    Date.parse("#{year}-#{month}-01")
  end
end
