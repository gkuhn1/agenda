module Create

  def self.included(base)
    base.send :include, BaseConcernController
  end

  def create
    object = get_model.new(self.send(self.controller_name.singularize + "_params"))

    instance_variable_set(get_variable, object)

    respond_to do |format|
      if instance_variable_get(get_variable).save
        format.html { redirect_to "/" + self.controller_path, notice: "Registro criado com sucesso" }
        format.json { render :show, status: :created }
      else
        format.html { render :new }
        format.json { render json: {errors: instance_variable_get(get_variable).errors}, status: :unprocessable_entity }
      end
    end
  end
end
