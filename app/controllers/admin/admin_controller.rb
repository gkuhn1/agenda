class Admin::AdminController < ApplicationController
  include OnlyJson

  before_filter :admin_required!

end