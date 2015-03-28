class Admin::HomepagesController < ApplicationController
  before_filter :set_admin_context
  before_filter :admin_required!

  add_breadcrumb "<i class=\"fa fa-dashboard\"></i> Administração".html_safe, :admin_homepages_path

  def set_admin_context
    @admin = true
    @title = "Administração"
  end

end