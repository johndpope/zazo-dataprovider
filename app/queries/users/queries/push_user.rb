class Users::Queries::PushUser < Query::Base
  attr_reader :user_mkey, :push_user
  validates   :user_mkey, presence: true
  validate    :validate_push_user_presence

  after_initialize :set_options

  def execute
    allowed_attrs.each_with_object({}) do |attr, memo|
      memo[attr] = push_user.send(attr)
    end
  end

  private

  def set_options
    @user_mkey = options['user_mkey']
    @push_user = ::PushUser.find_by(mkey: user_mkey)
  end

  def allowed_attrs
    %i(mkey push_token device_platform device_build)
  end

  def validate_push_user_presence
    errors.add(:push_user, 'user mkey is not correct') if user_mkey && !push_user
  end
end
