require 'rails_helper'

RSpec.describe Users::Queries::PushUser, type: :model do
  let(:push_user) { FactoryGirl.create :push_user }
  let(:instance) { described_class.new options }

  describe '#execute' do
    let(:options) { { user_mkey: push_user.mkey } }
    subject { instance.execute }

    it do
      expected = {
        mkey:            push_user.mkey,
        push_token:      push_user.push_token,
        device_platform: push_user.device_platform,
        device_build:    push_user.device_build
      }
      is_expected.to eq expected
    end
  end

  describe 'validations' do
    before  { instance.valid? }
    subject { instance.valid? }
    let(:errors) { instance.errors.messages }

    context 'with correct mkey' do
      let(:options) { { user_mkey: push_user.mkey } }

      it { is_expected.to be true }
      it { expect(errors).to eq Hash.new }
    end

    context 'without mkey' do
      let(:options) { Hash.new }

      it { is_expected.to be false }
      it { expect(errors).to eq user_mkey: ['can\'t be blank'] }
    end

    context 'with invalid mkey' do
      let(:options) { { user_mkey: 'xxxxxxxxxxxx' } }

      it { is_expected.to be false }
      it { expect(errors).to eq push_user: ['user mkey is not correct'] }
    end
  end
end
