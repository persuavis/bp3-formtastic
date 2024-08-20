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

                # PrependInputs provides formtastic input overrides
                module PrependInputs
                  def input_wrapping(&)
                    return super if column.nil? # e.g. when called for individual details fields
                    return super if Bp3::Formtastic.input_control_class.nil?
                    return super unless builder.respond_to?(:viz)
                    return nil if column.name.in?(EXCLUDED_COLUMNS)

                    builder.id&.gsub(/_#{UUID_REGEX}/, '')
                    viz = builder.viz(field_name, dom_id)
                    return nil if viz.present? && !viz.show_element

                    super
                  end

                  private

                  def input_control_class
                    Bp3::Formtastic.input_control_class
                  end

                  def field_name
                    "#{object_name}[#{input_name}]"
                  end
                end

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
