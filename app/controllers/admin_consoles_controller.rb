class AdminConsolesController < ApplicationController
  load_and_authorize_resource

  def show
    @admin_console = AdminConsole.new(params[:page])
  end
end
