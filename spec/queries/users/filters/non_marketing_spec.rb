require 'rails_helper'

RSpec.describe Users::Filters::NonMarketing, type: :model do
  let(:instance) { described_class.new params }

  describe '#execute' do
    subject { instance.execute }

    describe 'structure' do
      let(:params) { {} }
      let(:time) { '2016-02-19 00:00:00' }
      let(:inviter) { gen_hash }
      let(:invitee) { gen_hash }

      before { send_invite_at_flow inviter, invitee, time }

      it do
        expected = {
          'invitee'   => invitee,
          'inviter'   => inviter,
          'time_zero' => time
        }
        is_expected.to eq [expected]
      end
    end

    describe 'pagination' do
      before do
        99.times { send_invite_at_flow gen_hash, gen_hash }
      end

      context 'page 1' do
        let(:params) { { page: 1 } }
        it { is_expected.to have(50).items }
      end

      context 'page 2' do
        let(:params) { { page: 2 } }
        it { is_expected.to have(49).items }
      end

      context 'custom per page' do
        let(:params) { { page: 3, per_page: 34 } }
        it { is_expected.to have(31).items }
      end
    end

    describe 'recent' do
      before do
        Timecop.travel(4.weeks.ago) do
          10.times { send_invite_at_flow gen_hash, gen_hash }
        end
        Timecop.travel(5.days.ago) do
          10.times { send_invite_at_flow gen_hash, gen_hash }
        end
      end

      context 'disabled' do
        let(:params) { { recent: false } }
        it { is_expected.to have(20).items }
      end

      context 'enabled' do
        let(:params) { { recent: true } }
        it { is_expected.to have(10).items }
      end
    end
  end
end
