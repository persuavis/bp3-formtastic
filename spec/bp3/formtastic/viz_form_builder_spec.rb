# frozen_string_literal: true

RSpec.describe Bp3::Formtastic::VizFormBuilder do
  let(:controller) do
    Struct.new(:current_site, :current_tenant, :current_workspace, :action_name)
          .new('site', 'tenant', 'workspace', 'new')
  end
  let(:template) { Struct.new(:controller).new(controller) }
  # Allocated rather than built: outside Rails, ActionView's FormBuilder is not there to initialize.
  let(:builder) { described_class.allocate.tap { |b| b.instance_variable_set(:@template, template) } }

  # A page acting on a target site must not file the record there: load_vizfacts reads by the
  # controller's current_site, so a record filed elsewhere is never found again.
  it "files a new input control record under the controller's site, tenant and workspace" do
    attrs = builder.send(:vizfact_attrs, 'thing[name]', 'thing_name')
    expect(attrs).to include(sites_site: 'site', tenant: 'tenant', workspaces_workspace: 'workspace')
  end
end
