class AdminConsolesController < ApplicationController
  before_filter :require_admin

  def show
    @admin_console = AdminConsole.new(params[:page])
  end
end
