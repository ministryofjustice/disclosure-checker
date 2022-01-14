module FormAttributeMethods
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    # Add the ability to read/write attributes without calling their accessor methods.
    # Needed to behave more like an ActiveRecord model, where you can manipulate the
    # database attributes making use of `self[:attribute]`
    def [](attr_name)
      instance_variable_get("@#{attr_name}".to_sym)
    end

    def []=(attr_name, value)
      instance_variable_set("@#{attr_name}".to_sym, value)
    end

    def attributes_map
      self.class.attributes_map(self)
    end
  end

  module ClassMethods
    # Iterates through all declared attributes in the form object, mapping its values
    def attributes_map(origin)
      attribute_set.to_h { |attr| [attr.name, origin[attr.name]] }
    end
  end
end
