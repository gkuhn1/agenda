module Update
  extend ActiveSupport::Concern

  def update
    object = get_object or return
    instance_variable_set(get_variable, object)

    if instance_variable_get(get_variable).update(self.send(self.controller_name.singularize + "_params"))
      flash[:notice] = "Registro atualizado com sucesso"
      redirect_to "/" + self.controller_path
    else
      breadrumb_for_actions("editar")

      render :edit
    end
  end
end
