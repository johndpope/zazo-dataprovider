require 'rails_helper'

RSpec.describe Users::Queries::MutualFriends, type: :model do
  let(:instance) { described_class.new user_mkey: user_mkey, contact_mkey: contact_mkey }

  describe '#execute' do
    let(:user)    { FactoryGirl.create :user }
    let(:contact) { FactoryGirl.create :user }

    let(:friend_1) { FactoryGirl.create :user }
    let(:friend_2) { FactoryGirl.create :user }
    let(:friend_3) { FactoryGirl.create :user }

    let(:not_friend_1) { FactoryGirl.create :user }
    let(:not_friend_2) { FactoryGirl.create :user }
    let(:not_friend_3) { FactoryGirl.create :user }

    before do
      [friend_1, friend_2, friend_3].each do |friend|
        creator, target = [user, friend].shuffle
        FactoryGirl.create :connection, creator: creator, target: target
      end
      [friend_1, friend_3].each do |friend|
        creator, target = [contact, friend].shuffle
        FactoryGirl.create :connection, creator: creator, target: target
      end
      [not_friend_2, not_friend_3].each do |friend|
        creator, target = [not_friend_1, friend].shuffle
        FactoryGirl.create :connection, creator: creator, target: target
      end
    end

    subject { instance.execute }

    context 'friends exist' do
      let(:user_mkey) { user.mkey }
      let(:contact_mkey) { contact.mkey }

      it { is_expected.to match_array [friend_1.mkey, friend_3.mkey] }
    end

    context 'friends not exits' do
      let(:user_mkey) { user.mkey }
      let(:contact_mkey) { not_friend_1.mkey }

      it { is_expected.to eq [] }
    end
  end
end
