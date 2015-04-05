module BaseConcernController
  extend ActiveSupport::Concern

  def custom_order(collection)
    collection.order_by(created_at: 1)
  end

  def get_variable
    '@'+self.controller_name.singularize
  end

  def get_variable_plural
    '@'+self.controller_name.pluralize
  end

  def get_model
    self.controller_name.classify.constantize
  rescue
    nil
  end

  def get_object
    get_collection.find(params[:id])
  end

  def get_collection
    get_model
  end

end