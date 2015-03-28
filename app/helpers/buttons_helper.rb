module ButtonsHelper

  def link_to_icon(text, path, icon, params={})
    link_to "<i class=\"#{icon}\"></i> #{text}".html_safe, path, params
  end

  def edit_buttom(path, text="Editar")
    link_to_icon text, path, "fa fa-pencil", :class => "btn btn-warning"
  end

  def destroy_buttom(path, text="Excluir")
    link_to_icon text, path, "fa fa-trash-o", :data => { :confirm => 'Confirmar exclusão deste item?' }, :class => "btn btn-danger"
  end

  def show_buttom(path, text="Exibir")
    link_to_icon text, path, "fa fa-asterisk", :class => "btn btn-info"
  end

  def add_buttom(path, text="Novo")
    link_to_icon text, path, "fa fa-plus-circle", :class => "btn btn-success"
  end

  def cancel_buttom(path, text="Cancelar")
    link_to_icon text, path, "fa fa-times-circle", :class => "btn btn-danger"
  end

end
