class Users::Filters::SpecificUsers < Query::Base
  include Query::Shared::RunRawQuery
  include Query::Shared::StripData

  attr_reader :users
  validates   :users, presence: true

  after_initialize :set_options

  def execute
    strip_data run_raw_query_on_users(query), %w(invitee inviter)
  end

  private

  def query
    sql = <<-SQL
      SELECT
        users.id,
        users.mkey,
        max_time_zero.connection_id,
        max_time_zero.time_zero,
        CONCAT(users.first_name, ' ', users.last_name) invitee,
        CONCAT(inviters.first_name, ' ', inviters.last_name) inviter
      FROM users
        INNER JOIN (
          SELECT
            users.mkey,
            MAX(connections.id) connection_id,
            MAX(connections.created_at) time_zero
          FROM users
            INNER JOIN connections ON users.id = connections.target_id
          WHERE users.mkey IN (?)
          GROUP BY users.mkey
        ) AS max_time_zero ON max_time_zero.mkey = users.mkey
        INNER JOIN connections ON connections.target_id = users.id AND
                                  connections.created_at = max_time_zero.time_zero
        INNER JOIN users inviters ON inviters.id = connections.creator_id
    SQL
    User.send :sanitize_sql_array, [sql, users]
  end

  def set_options
    @users = options[:users]
  end
end
