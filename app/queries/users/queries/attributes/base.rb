class Users::Queries::Attributes::Base
  attr_reader :user

  def initialize(user)
    @user = user
  end
end
