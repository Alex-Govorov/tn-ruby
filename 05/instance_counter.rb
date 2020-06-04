module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end
  module ClassMethods
    attr_reader :instances
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.instance_eval { @instances = 0 } if self.class.instances.nil?
      self.class.instance_eval { @instances += 1 }
    end
  end
end
