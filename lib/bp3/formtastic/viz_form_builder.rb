# frozen_string_literal: true

require 'active_support'
require 'action_view/helpers/form_options_helper'
require 'rails/engine'
require 'formtastic'

module Bp3
  module Formtastic
    class VizFormBuilder < ::Formtastic::FormBuilder
      attr_reader :vizfacts

      def initialize(...)
        super
        load_vizfacts
      end

      def input(method, options = {})
        super
      end

      def viz(element_name, element_ident)
        return if vizfacts.nil?

        vizfacts.detect { |vf| vf.element_name == element_name || vf.element_ident == element_ident }
      end

      private

      # Filed under the site load_vizfacts reads from, so the next render finds the record, and under
      # that site's tenant and workspace. Left to the model's defaults, a page acting on a target site
      # would take its site, tenant or workspace from the target instead.
      def vizfact_attrs(element_name, element_ident)
        {
          sites_site: site,
          tenant: template.controller.send(:current_tenant),
          workspaces_workspace: template.controller.send(:current_workspace),
          element_controller: template.controller.class.name,
          element_action: template.controller.action_name,
          element_name:,
          element_ident:,
          show_element: true
        }
      end

      def load_vizfacts
        return if input_control_class.nil?

        controller = template.controller.class.name
        action = template.controller.action_name
        @vizfacts = input_control_class.where(sites_site: site, element_controller: controller,
                                              element_action: action).to_a
      end

      def site
        @site ||= template.controller.send(:current_site)
      end

      def input_control_class
        Bp3::Formtastic.input_control_class
      end
    end
  end
end
