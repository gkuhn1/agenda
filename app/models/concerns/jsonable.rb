module Jsonable

  def to_json
    view = ApplicationController.view_context_class.new("#{Rails.root}/app/views")
    JbuilderTemplate.new(view).encode do |json|
      json.partial!("api/v1/#{plural_name}/show", Hash[singular_name.to_sym, self])
    end.to_json
  end

  def singular_name
    self.class.name.downcase
  end

  def plural_name
    singular_name.pluralize
  end

end