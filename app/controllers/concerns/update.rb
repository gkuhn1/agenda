module Update
  extend ActiveSupport::Concern

  def update
    object = get_object or return
    instance_variable_set(get_variable, object)

    respond_to do |format|
      if instance_variable_get(get_variable).update(self.send(self.controller_name.singularize + "_params"))
        format.html { redirect_to "/" + self.controller_path, notice: "Registro atualizado com sucesso" }
        format.json { render :show, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: instance_variable_get(get_variable).errors, status: :unprocessable_entity }
      end
    end

  end
end
