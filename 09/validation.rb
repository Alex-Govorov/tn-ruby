module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end
  module ClassMethods
    attr_reader :validations

    def validate(arg, validation_type, options = nil)
      @validations ||= {}
      @validations[arg] ||= {}
      @validations[arg][validation_type] = options
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |arg, validations|
        value = instance_variable_get("@#{arg}")
        validations.each { |type, options| send("validate_#{type}", value, *options) }
      end
    end

    def valid?
      validate!
      true
    rescue StandartError
      false
    end

    private

    def validate_presence(name)
      raise 'Name is nil or empty' if name.to_s.empty?
    end

    def validate_format(number, format)
      raise 'Invalid format' unless number.to_s =~ format
    end

    def validate_type(value, type)
      raise 'Invalid type' unless value.is_a? type
    end
  end
end
