class Admin::HomepagesController < ApplicationController

  before_filter :set_admin_context

  def index
  end

  def set_admin_context
    @admin = true
    @title = "Administração"
  end

  def breadrumb_for_actions(description=nil)
    super("Administração")
  end

end