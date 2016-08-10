require 'rails_helper'

RSpec.describe Users::Queries::FindByMobile, type: :model do
  let(:instance) { described_class.new(params) }

  describe '#execute' do
    let(:friend) { FactoryGirl.create(:user) }

    subject { instance.execute }

    before do
      FactoryGirl.create(:user, mkey: 'xxxxxxxxxxx1', mobile_number: '+16502453531')
      FactoryGirl.create(:user, mkey: 'xxxxxxxxxxx2', mobile_number: '+16502453532')
      FactoryGirl.create(:user, mkey: 'xxxxxxxxxxx3', mobile_number: '+16502453533')
      FactoryGirl.create(:user, mkey: 'xxxxxxxxxxx4', mobile_number: '+16502453534')
      FactoryGirl.create(:user, mkey: 'xxxxxxxxxxx5', mobile_number: '+16502453535')

      target_creator = [friend, User.find_by_mkey('xxxxxxxxxxx4')].shuffle
      FactoryGirl.create(:connection, target: target_creator[0], creator: target_creator[1])
    end

    context 'when found' do
      context 'with existent friendship' do
        let(:params) { { phones: %w(+16502453533 +16502453534 +16502453535), friend: friend.mkey } }

        it { expect(subject[:mkey]).to eq('xxxxxxxxxxx4') }
      end

      context 'with non existent friendship' do
        let(:params) { { phones: %w(+16502453533 +16502453534), friend: 'xxxxxxxxxxx' } }

        it { expect(subject[:mkey]).to eq('xxxxxxxxxxx3') }
      end

      context 'without friendship' do
        let(:params) { { phones: %w(+16502453533 +16502453534) } }

        it { expect(subject[:mkey]).to eq('xxxxxxxxxxx3') }
      end
    end

    context 'when not found' do
      let(:params) { { phones: '16502453530' } }

      it { expect(subject[:mkey]).to be_nil }
    end
  end

  describe 'validations' do
    subject { instance.valid? }

    context 'when valid by single phone' do
      let(:params) { { phones: '16502453533', friend: 'xxxxxxxxxxx' } }

      it { is_expected.to be(true) }
    end

    context 'when valid by multiple phone' do
      let(:params) { { phones: %w(+16502453533 +16502453534) } }

      it { is_expected.to be(true) }
    end

    context 'when invalid by phones' do
      let(:params) { {} }

      it { is_expected.to be(false) }
      it do
        subject
        expect(instance.errors.messages).to eq(phones: ['can\'t be blank'])
      end
    end
  end
end
