module New
  extend ActiveSupport::Concern

  def new
    instance_variable_set(get_variable, get_model.new)
    add_breadcrumb("Adicionar")
  end
end
