class Users::Queries::IdsAndNames < Query::Base
  attr_reader :users
  validates   :users, presence: true

  after_initialize :set_options

  def execute
    User.where(mkey: users).each_with_object({}) do |user, memo|
      memo[user.mkey] = { id: user.id, name: user.name }
    end
  end

  private

  def set_options
    @users = options[:users]
  end
end
