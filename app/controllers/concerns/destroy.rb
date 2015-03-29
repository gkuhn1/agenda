module Destroy
  extend ActiveSupport::Concern

  def destroy
    object = get_object or return

    object.destroy

    respond_to do |format|
      format.html { redirect_to "/" + self.controller_path, notice: "Registro excluído com sucesso" }
      format.json { head :no_content }
    end
  end
end
