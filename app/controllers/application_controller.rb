class NoAccountSelectedException < RuntimeError; end
class NoUserSelectedException < RuntimeError; end
class AdminRequiredException < RuntimeError; end


class ApplicationController < ActionController::Base
  include Index, Show, New, Edit, Update, Create, Destroy
  # before_action :authenticate_user! #method for devise
  before_filter :authenticate
  before_filter :user_required, :account_required
  after_filter :reset_database

  rescue_from NoAccountSelectedException, with: :permission_denied
  rescue_from NoUserSelectedException, with: :permission_denied
  rescue_from AdminRequiredException, with: :permission_denied
  rescue_from ActionController::UnknownFormat, with: :not_acceptable
  rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found

  attr_accessor :current_account, :current_user

  helper_method :title, :subtitle, :current_account, :current_user, :context_admin?, :breadrumb_to_menus

  # protect_from_forgery
  # protect_from_forgery with: :exception
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # after_filter :set_csrf_cookie_for_ng

  # def set_csrf_cookie_for_ng
  #   cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  # end

  # In Rails 4.2 and above
  # def verified_request?
  #   super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
  # end

  # Exceptions
  def account_required
    raise NoAccountSelectedException if current_account.nil?
    switch_database
  end

  def user_required
    raise NoUserSelectedException if current_user.nil?
  end

  def admin_required!
    raise AdminRequiredException if !(current_user and current_user.admin?)
  end

  protected

    # rescues
    def not_acceptable
      render :json => {:error => 'Not Acceptable'}, :status => 406
    end

    def not_found
      render :json => {:error => 'Not Found'}, :status => 404
    end

    def permission_denied
      render :json => {:error => 'Unauthorized'}, :status => 401
    end

  private

    # before filter
    def authenticate
      # authenticate_or_request_with_http_basic do |user_token, account_id, options|
      authenticate_with_http_basic do |user_token, account_id, options|
        @current_user = User.find_by(token: user_token) if user_token
        @current_account = current_user.accounts.where(id: account_id).first if current_user and account_id
      end
    rescue Mongoid::Errors::DocumentNotFound
      raise NoUserSelectedException
    end

    def switch_database
      Mongoid.set_current_database(current_account.database)
    end

    def reset_database
      Mongoid.destroy_current_database
    end

end
