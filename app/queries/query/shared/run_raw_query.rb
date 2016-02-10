module Query::Shared::RunRawQuery
  def run_raw_query_on_events(query)
    Event.connection.select_all(query)
  end

  def run_raw_query_on_users(query)
    User.connection.select_all(query)
  end
end
