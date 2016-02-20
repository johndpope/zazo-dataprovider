require 'rails_helper'

RSpec.describe Users::Filters::NonVerified, type: :model do
  let(:instance) { described_class.new params }

  describe '#execute' do
    subject { instance.execute }

    describe 'structure' do
      let(:params) { {} }
      let!(:conn) { FactoryGirl.create :connection }

      it do
        expected = {
          'id'            => conn.target.id,
          'mkey'          => conn.target.mkey,
          'connection_id' => conn.id,
          'time_zero'     => conn.created_at.to_s,
          'invitee'       => conn.target.name,
          'inviter'       => conn.creator.name
        }
        is_expected.to include expected
      end
    end

    describe 'pagination' do
      before do
        99.times { FactoryGirl.create :connection }
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
          10.times { FactoryGirl.create :connection }
        end
        Timecop.travel(5.days.ago) do
          10.times { FactoryGirl.create :connection }
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
