require 'rails_helper'

RSpec.describe Users::Queries::FindByMobileOrEmail, type: :model do
  let(:instance) do
    described_class.new mobile: (mobile rescue nil), email: (email rescue nil)
  end

  describe '#execute' do
    subject { instance.execute }

    before do
      FactoryGirl.create :user, mkey: 'xxxxxxxxxxx1', mobile_number: '+16502453531'
      FactoryGirl.create :user, mkey: 'xxxxxxxxxxx2', mobile_number: '+16502453532', emails: %w(xxx21@zazo.com xxx22@zazo.com)
    end

    context 'found by mobile' do
      let(:mobile) { '+16502453531' }
      it { expect(subject[:mkey]).to eq 'xxxxxxxxxxx1' }
    end

    context 'found by email' do
      let(:mobile) { '+16502453533' }
      let(:email) { 'xxx22@zazo.com' }
      it { expect(subject[:mkey]).to eq 'xxxxxxxxxxx2' }
    end

    context 'not found' do
      let(:mobile) { '+16502453533' }
      let(:email) { 'xxx23@zazo.com' }
      it { expect(subject[:mkey]).to be_nil }
    end
  end
end
