module Destroy

  def self.included(base)
    base.send :include, BaseConcernController
  end

  def destroy
    get_object.destroy

    respond_to do |format|
      format.html { redirect_to "/" + self.controller_path, notice: "Registro excluído com sucesso" }
      format.json { head :no_content }
    end
  end
end
