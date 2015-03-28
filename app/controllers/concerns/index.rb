module Index
  extend ActiveSupport::Concern

  def index
    if get_model
      instance_variable_set('@q', get_model.search(params[:q]))
      instance_variable_set('@'+self.controller_name.pluralize, instance_variable_get("@q").result.order_by(created_at: 1).paginate(:page => params[:page]))
    end
  end
end
