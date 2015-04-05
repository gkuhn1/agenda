class Api::V1::NoAuthenticatedException < RuntimeError; end
class Api::V1::NotAcceptableParameters < RuntimeError; end

class Api::V1::ApiController < ApplicationController
  respond_to :json

  # This is our new function that comes before Devise's one
  before_filter :respond_only_json
  before_filter :authenticate_user_from_token!, :require_current_account
  # skips Devise's authentication
  skip_before_filter :authenticate_user!

  rescue_from Api::V1::NotAcceptableParameters, :with => :not_acceptable
  rescue_from ActionController::UnknownFormat, :with => :not_acceptable
  rescue_from Api::V1::NoAuthenticatedException, :with => :permission_denied
  rescue_from Mongoid::Errors::DocumentNotFound, :with => :not_found

  protected

    def not_acceptable
      render :json => {:error => 'Not Acceptable'}, :status => 406
    end

    def not_found
      render :json => {:error => 'Not Found'}, :status => 404
    end

    def permission_denied
      render :json => {:error => 'Unauthorized'}, :status => 401
    end

    def respond_only_json
      raise Api::V1::NotAcceptableParameters unless env["CONTENT_TYPE"] =~ /application\/json/ or params['format'] == 'json'
    end

  private

  def require_current_account
    user_account     = params[:user_account].presence
    @current_account = user_account && current_user && current_user.accounts.find(user_account)
  rescue
    raise NoAccountSelectedException
  end

  def authenticate_user_from_token!
    user_email   = params[:user_email].presence
    user         = user_email && User.find_by(email: user_email)



    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.token, params[:user_token])
      sign_in user, store: false
    else
      raise Api::V1::NoAuthenticatedException
    end
  end
end