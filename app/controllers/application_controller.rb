class NoAccountSelectedException < RuntimeError; end
class AdminRequiredException < RuntimeError; end


class ApplicationController < ActionController::Base
  include Index, Show, New, Edit, Update, Create, Destroy, Search
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :set_csrf_cookie_for_ng
  before_action :authenticate_user!

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :account_required, unless: :devise_controller?

  layout :layout_by_resource

  rescue_from NoAccountSelectedException, :with => :need_to_select_an_account

  helper_method :title, :subtitle, :current_account, :context_admin?, :breadrumb_to_menus

  protect_from_forgery

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u|
      u.permit(:name, :email, :password, :password_confirmation, :current_password)
    }
  end

  def breadrumb_to_menus
    @breadcrumb_to_menus ||= AgendaBreadcrumbBuilder.new(self, breadcrumbs, {}).compute_all_paths
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
      redirect_to "/" + self.controller_path and return
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
    @current_account ||= Account.find(session[:account_id] || params[:user_account]) if session[:account_id] || params[:user_account]
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
    message = 'Selecione uma conta antes de fazer alterações.'
    respond_to do |format|
      format.html do
        flash[:alert] = message
        redirect_to(select_account_homepages_path)
      end
      format.json { render :json => {:error => message}, :status => 401}
    end
  end

  protected

    # In Rails 4.2 and above
    def verified_request?
      super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
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
