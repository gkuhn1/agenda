module BSON
  class ObjectId
    def as_json(*args)
      to_s
    end

    alias :to_json :as_json
  end
end

module Mongoid
  module Fields

    def self.included(base)
      id_field = base.fields["_id"]
      if id_field and id_field.type == BSON::ObjectId
        base.send(:define_method, :id) do
          _id.to_s
        end
      end
    end

  end
end