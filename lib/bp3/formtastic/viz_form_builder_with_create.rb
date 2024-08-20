# frozen_string_literal: true

module Bp3
  module Formtastic
    class VizFormBuilderWithCreate < VizFormBuilder
      def viz(element_name, element_ident)
        return if vizfacts.nil?

        record = super
        return record if record

        create_input_control_record(element_name, element_ident)
      end

      private

      def create_input_control_record(element_name, element_ident)
        attrs = vizfact_attrs(element_name, element_ident)
        Vizfact::Input.unscoped.create!(attrs)
      end
    end
  end
end
