module Index
  extend ActiveSupport::Concern

  def index
    breadrumb_for_actions
    instance_variable_set('@q', get_model.search(params[:q]))
    instance_variable_set('@'+self.controller_name.pluralize, instance_variable_get("@q").result.order(:id).paginate(:page => params[:page]))
  end
end
