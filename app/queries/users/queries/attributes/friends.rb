class Users::Queries::Attributes::Friends < Users::Queries::Attributes::Base
  def value
    select_connections do |conn|
      [conn.target.mkey, conn.creator.mkey]
    end
  end

  protected

  def select_connections
    connections.each_with_object(Set.new) do |conn, memo|
      memo.merge(yield(conn))
    end.delete(user.mkey).to_a
  end

  def connections
    user.connections.includes(:target, :creator)
  end
end
