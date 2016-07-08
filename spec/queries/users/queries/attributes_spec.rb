require 'rails_helper'

RSpec.describe Users::Queries::Attributes, type: :model do
  let!(:conn) do
    target = FactoryGirl.create(:user, mobile_number: '+380939523747')
    FactoryGirl.create(:connection, target: target)
  end
  let(:user) { conn.target.mkey }
  let(:instance) { described_class.new(options) }

  describe '#execute' do
    subject { instance.execute }

    context 'when single user' do
      describe 'mkey, first_name, status' do
        let(:options) { { user: user, attrs: [:mkey, :first_name, :status] } }

        it do
          expected = {
            mkey:       conn.target.mkey,
            first_name: conn.target.first_name,
            status:     conn.target.status }
          is_expected.to eq(expected)
        end
      end

      describe 'country' do
        let(:options) { { user: user, attrs: :country } }

        it { is_expected.to eq(country: 'UA') }
      end

      describe 'friends' do
        let!(:friend_conn_1) { FactoryGirl.create(:connection, target: conn.target) }
        let!(:friend_conn_2) { FactoryGirl.create(:connection, creator: conn.target) }
        let(:options) { { user: user, attrs: :friends } }

        before do
          # non-friend connections
          10.times { FactoryGirl.create(:connection) }
        end

        it do
          expected = [friend_conn_1.creator.mkey, friend_conn_2.target.mkey, conn.creator.mkey]
          expect(subject[:friends]).to match_array(expected)
        end
      end
    end

    context 'when collection of users' do
      let(:users) { 5.times.map { FactoryGirl.create(:user) } }

      describe 'mkey, first_name, status' do
        let(:options) { { users: users.map(&:mkey), attrs: [:mkey, :first_name, :status] } }

        it do
          expected = users.map { |u| { mkey: u.mkey, first_name: u.first_name, status: u.status } }
          is_expected.to match_array(expected)
        end
      end
    end
  end

  describe 'validations' do
    let(:errors) { instance.errors.messages }
    subject { instance.valid? }
    before  { instance.valid? }

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
