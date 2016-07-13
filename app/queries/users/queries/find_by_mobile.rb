class Users::Queries::FindByMobile < Query::Base
  attr_reader :phones, :friend
  validates :phones, presence: true

  after_initialize :set_options

  def execute
    users = User.where(mobile_number: phones)
    user = user_by_friendship(users) || users.first
    { id: user.try(:id), mkey: user.try(:mkey) }
  end

  private

  def set_options
    @phones = Array.wrap(options['phones'])
    @friend = options['friend']
  end

  def user_by_friendship(users)
    users.find do |user|
      !!user.connections.find { |conn| conn.target.mkey == friend || conn.creator.mkey == friend }
    end
  end
end
