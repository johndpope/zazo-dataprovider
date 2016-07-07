class Users::Queries::MessagesCount < Query::Base
  include Query::Shared::RunRawQuery

  attr_reader :user_mkey
  validates :user_mkey, presence: true

  after_initialize :set_options

  def execute
    run_raw_query_on_events(query)[0]
  end

  private

  def query
    sql = <<-SQL
      WITH video_events AS (
        SELECT
          data->>'sender_id' sender,
          data->>'receiver_id' receiver,
          message_id
        FROM events
        WHERE
          name @> ARRAY['video', 's3', 'uploaded']::VARCHAR[] AND (
            data->>'sender_id'   = ? OR
            data->>'receiver_id' = ?
          )
        GROUP BY sender, receiver, message_id
      ) SELECT
          (SELECT COUNT(message_id) FROM video_events WHERE sender   = ?) outgoing,
          (SELECT COUNT(message_id) FROM video_events WHERE receiver = ?) incoming,
          COUNT(DISTINCT sender) active_friends
        FROM video_events
        WHERE sender != ?
    SQL
    Event.send(:sanitize_sql_array, [sql] + [user_mkey] * 5)
  end

  def set_options
    @user_mkey = options['user_mkey']
  end
end
