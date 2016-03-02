class Users::Queries::Attributes::Friends < Users::Queries::Attributes::Base
  def value
    mkeys = Set.new
    connections.each do |conn|
      mkeys.merge [conn.target.mkey, conn.creator.mkey]
    end
    mkeys.delete(user.mkey).to_a
  end

  private

  def connections
    user.connections.includes(:target, :creator)
  end
end
