class NoAccountSelectedException < RuntimeError; end
class AdminRequiredException < RuntimeError; end


class ApplicationController < ActionController::Base
  include Index, Show, New, Edit, Update, Create, Destroy
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :set_csrf_cookie_for_ng
  before_action :authenticate_user!

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :account_required, unless: :devise_controller?

  rescue_from NoAccountSelectedException, :with => :need_to_select_an_account

  helper_method :title, :subtitle, :current_account, :context_admin?, :breadrumb_to_menus

  protect_from_forgery

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def current_account
    @current_account ||= Account.find(session[:account_id] || params[:user_account]) if session[:account_id] || params[:user_account]
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
      format.json { render :json => {:error => message}, :status => 404}
    end
  end

  protected

    # In Rails 4.2 and above
    def verified_request?
      super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
    end

end
