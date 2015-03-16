module Destroy
  extend ActiveSupport::Concern

  def destroy
    object = get_object or return

    object.destroy
    flash[:notice] = "Registro excluído com sucesso"

    redirect_to "/" + self.controller_path
  end
end
