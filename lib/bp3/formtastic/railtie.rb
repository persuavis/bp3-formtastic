# frozen_string_literal: true

module Bp3
  module Formtastic
    if defined?(Rails.env)
      class Railtie < Rails::Railtie
        initializer 'bp3.formtastic.railtie.register' do |app|
          app.config.after_initialize do
            ::Formtastic::Inputs # preload
            module ::Formtastic
              module Inputs
                EXCLUDED_COLUMNS = %w[rqid sqnr].freeze
                UUID_REGEX = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/

                # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
                # PrependInputs provides formtastic input overrides
                module PrependInputs
                  def input_wrapping(&)
                    return super if column.nil? # e.g. when called for individual details fields
                    return nil if column.name.in?(EXCLUDED_COLUMNS)

                    # url = template.controller.request.url
                    site = template.controller.send(:current_site)
                    # tenant = template.controller.send(:current_tenant)
                    # workspace = template.controller.send(:current_workspace)
                    controller = template.controller.class.name
                    action = template.controller.action_name
                    builder.id.gsub(/_#{UUID_REGEX}/, '')
                    # puts "input_wrapping s:#{site.id} c:#{controller} a:#{action} " \
                    #                     "e:#{method} n:#{field_name} as:#{options[:as].inspect}"

                    viz = Vizfact::Input.where(sites_site: site,
                                               element_controller: controller,
                                               element_action: action,
                                               element_name: field_name)
                                        .or(Vizfact::Input.where(sites_site: site,
                                                                 element_controller: controller,
                                                                 element_action: action,
                                                                 element_ident: dom_id)).first
                    return nil if viz.present? && !viz.show_element

                    super
                  end

                  private

                  def field_name
                    "#{object_name}[#{input_name}]"
                  end
                end
                # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

                module Base
                  prepend PrependInputs
                end
              end
            end
          end
        end
      end
    end
  end
end
