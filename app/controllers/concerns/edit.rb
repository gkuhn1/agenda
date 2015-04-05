module Edit

  def self.included(base)
    base.send :include, BaseConcernController
  end

  def edit
    object = get_object or return

    instance_variable_set(get_variable, object)
  end
end
