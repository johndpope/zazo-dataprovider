require 'rails_helper'

RSpec.describe Users::Queries::Attributes, type: :model do
  let!(:conn) do
    target = FactoryGirl.create :user, mobile_number: '+380939523747'
    FactoryGirl.create :connection, target: target
  end
  let(:user) { conn.target.mkey }
  let(:instance) { described_class.new options }

  describe '#execute' do
    subject { instance.execute }

    context 'mkey, first_name, status' do
      let(:options) do
        { user: user, attrs: [:mkey, :first_name, :status] }
      end

      it do
        expected = {
          mkey:       conn.target.mkey,
          first_name: conn.target.first_name,
          status:     conn.target.status
        }
        is_expected.to eq expected
      end
    end

    context 'country' do
      let(:options) do
        { user: user, attrs: :country }
      end

      it { is_expected.to eq country: 'UA' }
    end
  end

  describe 'validations' do
    before  { instance.valid? }
    subject { instance.valid? }
    let(:errors) { instance.errors.messages }

    context 'without options' do
      let(:options) { Hash.new }

      it { is_expected.to be false }
      it { expect(errors).to eq user: ['can\'t be blank'], attrs: ['can\'t be blank'] }
    end

    context 'with disallowed attrs' do
      let(:options) { { user: conn.target.mkey, attrs: [:destroy] } }

      it { is_expected.to be false }
      it { expect(errors).to eq attrs: ['attr \'destroy\' is not allowed'] }
    end

    context 'with incorrect user' do
      let(:options) { { user: 'xxxxxxxxxxxx', attrs: [:id] } }

      it { is_expected.to be false }
      it { expect(errors).to eq user: ['can\'t be blank'] }
    end

    context 'with correct options' do
      let(:options) { { user: user, attrs: [:mkey, :first_name, :status] } }

      it { is_expected.to be true }
    end
  end
end
