class Users::Queries::Attributes::ActiveFriends < Users::Queries::Attributes::Friends
  def value
    select_connections do |conn|
      mkeys = []
      mkeys << conn.target.mkey if conn.target.verified?
      mkeys << conn.creator.mkey if conn.creator.verified?
      mkeys
    end
  end
end
