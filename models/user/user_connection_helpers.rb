module User::UserConnectionHelpers
  def connected_user_ids
    live_connections = Connection.for_user_id(id).established
    live_connections.map { |c| c.creator_id == id ? c.target_id : c.creator_id }
  end

  def connected_users
    User.where id: connected_user_ids
  end

  def connections
    Connection.for_user_id(id).includes(:creator).includes(:target)
  end

  def active_connections
    connections.select &:active?
  end
end
