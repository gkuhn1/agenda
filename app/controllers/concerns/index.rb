module Index

  def self.included(base)
    base.send :include, BaseConcernController
  end

  def index
    if get_model
      instance_variable_set('@q', get_collection.search(params[:q]))
      instance_variable_set(self.get_variable_plural, custom_order(instance_variable_get("@q").result).paginate(:page => params[:page]))
    end
  end

end
