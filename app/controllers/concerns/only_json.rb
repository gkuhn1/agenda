module OnlyJson

  module Exceptions
    class NotAcceptableParameters < RuntimeError; end
  end

  def self.included(base)
    base.send :respond_to, :json
    base.send :before_filter, :respond_only_json
    base.send :rescue_from, OnlyJson::Exceptions::NotAcceptableParameters, :with => :not_acceptable
  end

  def respond_only_json
    raise OnlyJson::Exceptions::NotAcceptableParameters unless request.format == 'json' # request.env["CONTENT_TYPE"] =~ /application\/json/ or params['format'] == 'json'
  end

end