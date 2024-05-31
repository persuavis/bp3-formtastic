# frozen_string_literal: true

RSpec.describe Bp3::Formtastic do
  it 'has a version number' do
    expect(Bp3::Formtastic::VERSION).not_to be_nil
  end

  describe 'config' do
    it 'supports input_control_class_name' do
      described_class.input_control_class_name = 'Bp3' # usually this would be an ActiveRecord model
      expect(described_class.input_control_class).to eq(Bp3)
    end
  end
end
