class Users::Queries::Attributes::Friends < Users::Queries::Attributes::Base
  def value
    connections.each_with_object(Set.new) do |conn, memo|
      memo.merge([conn.target.mkey, conn.creator.mkey])
    end.delete(user.mkey).to_a
  end

  private

  def connections
    user.connections.includes(:target, :creator)
  end
end
