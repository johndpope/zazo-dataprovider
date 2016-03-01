require 'rails_helper'

RSpec.describe Users::Queries::MessagesCount, type: :model do
  let(:instance) { described_class.new user_mkey: user_mkey }

  let(:user)     { gen_hash }
  let(:friend_1) { gen_hash }
  let(:friend_2) { gen_hash }

  let(:video_121) { video_data(user, friend_1, gen_video_id) }
  let(:video_122) { video_data(friend_1, user, gen_video_id) }
  let(:video_123) { video_data(user, friend_1, gen_video_id) }
  let(:video_124) { video_data(friend_1, user, gen_video_id) }

  let(:video_131) { video_data(user, friend_2, gen_video_id) }
  let(:video_132) { video_data(friend_2, user, gen_video_id) }
  let(:video_133) { video_data(user, friend_2, gen_video_id) }
  let(:video_134) { video_data(friend_2, user, gen_video_id) }

  describe '#execute' do
    let(:user_mkey) { user }
    subject { instance.execute }

    before do
      Timecop.travel(7.days.ago) { video_flow video_121 }
      Timecop.travel(6.days.ago) { video_flow video_122 }
      Timecop.travel(5.days.ago) { video_flow video_123 }
      Timecop.travel(4.days.ago) { video_flow video_124 }
      Timecop.travel(3.days.ago) { video_flow video_131 }
      Timecop.travel(2.days.ago) { video_flow video_132 }
      Timecop.travel(1.days.ago) { video_flow video_133 }
    end

    it do
      expected = { active_friends: '2', incoming: '3', outgoing: '4' }.stringify_keys
      is_expected.to eq expected
    end
  end
end
