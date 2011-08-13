class AdminConsolesController < ApplicationController
  load_and_authorize_resource

  expose(:admin_console) {AdminConsole.new(params[:page])}

  def show
  end
end
