require 'rails_helper'

RSpec.describe Fetch do
  let(:instance) { described_class.new *attributes }

  describe '#do' do
    subject { instance.do }

    context 'success' do
      let(:attributes) { [:users, :prefix, :sample_query, is_valid: true] }

      it { is_expected.to eq result: :success }
    end

    context 'invalid options' do
      let(:attributes) { [:users, :prefix, :sample_query, is_valid: false] }

      it { expect { subject }.to raise_error(Fetch::InvalidOptions) }
    end

    context 'invalid class' do
      let(:attributes) { [:users, :prefix, :nonexistent] }

      it { expect { subject }.to raise_error(Fetch::UnknownClass) }
    end
  end
end
