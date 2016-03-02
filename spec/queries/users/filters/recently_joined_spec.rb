require 'rails_helper'

RSpec.describe Users::Filters::RecentlyJoined, type: :model do
  let(:instance) { described_class.new time_frame_in_days: time_frame_in_days }

  describe '#execute' do
    let(:time_frame_in_days) { '25' }
    subject { instance.execute }

    before do
      [50.days.ago, 10.days.ago].each do |frame|
        Timecop.travel(frame) { 33.times { FactoryGirl.create :user } }
      end
    end

    describe 'results structure' do
      let(:time_frame_in_days) { '25' }
      it do
        expected = %i(id mkey mobile_number first_name last_name emails status)
        expect(subject.first.keys).to eq expected
      end
    end

    context 'recent for 25 days' do
      let(:time_frame_in_days) { '25' }
      it { expect(subject.size).to eq 33 }
    end

    context 'recent for 55 days' do
      let(:time_frame_in_days) { '55' }
      it { expect(subject.size).to eq 66 }
    end

    context 'recent for default days' do
      let(:time_frame_in_days) { nil }
      it { expect(subject.size).to eq 66 }
    end
  end
end
