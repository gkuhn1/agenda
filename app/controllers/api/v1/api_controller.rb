class Api::V1::NotAcceptableParameters < RuntimeError; end

class Api::V1::ApiController < ApplicationController
  respond_to :json

  before_filter :respond_only_json
  rescue_from Api::V1::NotAcceptableParameters, :with => :not_acceptable

  def respond_only_json
    raise Api::V1::NotAcceptableParameters unless request.format == 'json' # request.env["CONTENT_TYPE"] =~ /application\/json/ or params['format'] == 'json'
  end

end