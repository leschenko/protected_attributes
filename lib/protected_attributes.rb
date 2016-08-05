require "active_model/mass_assignment_security"
require "protected_attributes/railtie" if defined? Rails::Railtie
require "protected_attributes/version"

ActiveSupport.on_load :active_record do
  require "active_record/mass_assignment_security"
end

ActiveSupport.on_load :action_controller do
  require "action_controller/accessible_params_wrapper"
end

module ProtectedAttributes
end

module ActiveRecord
  module Core
    def initialize(attributes = nil, options = {})
      @attributes = self.class._default_attributes.dup
      self.class.define_attribute_methods

      init_internals
      initialize_internals_callback

      # +options+ argument is only needed to make protected_attributes gem easier to hook.
      init_attributes(attributes, options) if attributes

      yield self if block_given?
      _run_initialize_callbacks
    end
  end
end
