# frozen_string_literal: true

require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/inflector'

require_relative 'formtastic/viz_form_builder'
require_relative 'formtastic/viz_form_builder_with_create'
require_relative 'formtastic/railtie'
require_relative 'formtastic/version'

module Bp3
  module Formtastic
    mattr_accessor :input_control_class_name

    def self.input_control_class
      @@input_control_class ||= input_control_class_name&.constantize # rubocop:disable Style/ClassVars
    end
  end
end
