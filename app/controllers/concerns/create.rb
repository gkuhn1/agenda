module Create
  extend ActiveSupport::Concern

  def create
    object = get_model.new(self.send(self.controller_name.singularize + "_params"))

    instance_variable_set(get_variable, object)

    if instance_variable_get(get_variable).save
      flash[:notice] = "Registro criado com sucesso"
      redirect_to "/" + self.controller_path
    else
      breadrumb_for_actions("novo")
      render :new
    end
  end
end
