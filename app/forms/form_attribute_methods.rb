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
      name = attr_name.to_s

      if self.class.attribute_names.include?(name)
        @attributes.fetch_value(name)
      else
        instance_variable_get("@#{name}")
      end
    end

    def []=(attr_name, value)
      name = attr_name.to_s

      if self.class.attribute_names.include?(name)
        @attributes.write_from_user(name, value)
      else
        instance_variable_set("@#{name}", value)
      end
    end

    def attributes_map
      self.class.attributes_map(self)
    end
  end

  module ClassMethods
    # Iterates through all declared attributes in the form object, mapping its values
    def attributes_map(origin)
      attribute_names.map(&:to_sym).index_with { |name| origin[name] }
    end
  end
end
