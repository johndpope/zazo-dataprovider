class Users::Queries::ConnectionIds < Query::Base
  include Query::Shared::RunRawQuery

  attr_reader :users, :friends
  validates   :users, :friends, presence: true

  after_initialize :set_options

  def execute
    run_raw_query_on_users(query)
  end

  private

  def query
    sql = <<-SQL
      SELECT
        CONCAT(users.mkey, '-', friends.mkey) relation,
        connections.id connection_id,
        users.mkey user_mkey,
        friends.mkey friend_mkey,
        users.id user_id,
        friends.id friend_id
      FROM
        connections,
        (SELECT id, mkey FROM users WHERE mkey IN (?)) users,
        (SELECT id, mkey FROM users WHERE mkey IN (?)) friends
      WHERE (connections.creator_id = users.id AND connections.target_id = friends.id) OR
            (connections.creator_id = friends.id AND connections.target_id = users.id)
    SQL
    User.send :sanitize_sql_array, [sql, users, friends]
  end

  def set_options
    @users   = options[:users]
    @friends = options[:friends]
  end
end
