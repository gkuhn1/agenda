Apipie.configure do |config|
  config.app_name                = "API Agenda"
  config.api_base_url            = "/api/v1"
  config.doc_base_url            = "/apipie"
  config.process_params          = false
  config.validate                = :explicitly
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end


class Apipie::Application

  alias_method :orig_load_controller_from_file, :load_controller_from_file

  def load_controller_from_file(controller_file)
    begin
      orig_load_controller_from_file(controller_file)
    rescue LoadError => e
      controller_file.gsub(/\A.*\/app\/controllers\//,"").gsub(/\.\w*\Z/,"").gsub("concerns/","").camelize.constantize
    end
  end

end