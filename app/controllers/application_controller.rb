class NoAccountSelectedException < RuntimeError; end
class AdminRequiredException < RuntimeError; end


class ApplicationController < ActionController::Base
  include Index, New, Edit, Update, Create, Destroy, Search
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :account_required

  after_action :breadrumb_for_actions

  layout :layout_by_resource

  rescue_from NoAccountSelectedException, :with => :need_to_select_an_account

  helper_method :title, :subtitle, :current_account, :context_admin?

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u|
      u.permit(:name, :email, :password, :password_confirmation, :current_password)
    }
  end

  def breadrumb_for_actions(description=nil)
    add_breadcrumb get_model.model_name.human(count: 2), "/"+self.controller_path if get_model
    add_breadcrumb description unless description.nil?
  end

  def get_model
    self.controller_name.classify.constantize
  rescue
    nil
  end

  def get_variable
    '@'+self.controller_name.singularize
  end

  def get_object
    object = get_model.where(id: params[:id]).first

    if object.nil?
      flash[:error] = "Registro não encontrado"
      if params[:enterpreneur_id].present?
        redirect_to "/enterpreneurs/" + params[:enterpreneur_id] + "/" + self.controller_path and return
      else
        redirect_to "/" + self.controller_path and return
      end
    end

    object
  end

  # HelperMethods
  def title
    @title || "Agenda"
  end

  def subtitle
    @subtitle ||= t("action."+params[:action]) + " " + t("models."+self.controller_name.classify)
  end

  def current_account
    @current_account ||= Account.find(session[:account_id]) if session[:account_id]
  end

  def context_admin?
    @admin == true
  end

  # Exceptions
  def account_required
    raise NoAccountSelectedException if current_account.nil?
  end

  def admin_required!
    raise AdminRequiredException unless current_user.admin?
  end

  # rescues NoAccountSelectedException
  def need_to_select_an_account
    flash[:alert] = 'Selecione uma conta antes de fazer alterações.'
    respond_to do |format|
      format.html { redirect_to(select_account_homepages_path) }
    end
  end


  private

    def layout_by_resource
      if devise_controller?
        "login"
      else
        "application"
      end
    end

end
