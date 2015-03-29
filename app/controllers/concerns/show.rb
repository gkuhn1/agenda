module Show
  extend ActiveSupport::Concern

  def show
    object = get_object or return

    instance_variable_set(get_variable, object)
  end
end