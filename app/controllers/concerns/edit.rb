module Edit
  extend ActiveSupport::Concern

  def edit
    object = get_object or return

    instance_variable_set(get_variable, object)
    add_breadcrumb("Editar")
  end
end
