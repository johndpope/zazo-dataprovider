class Users::Filters::NonMarketing < Query::Base
  include Query::Shared::RunRawQuery
  include Query::Shared::Pagination
  include Query::Shared::RecentOnly

  recent_only_settings column: 'invited.time_zero',
                       append: true

  def execute
    run_raw_query_on_events(query).to_a
  end

  private

  def query
    <<-SQL
      WITH invited AS (
        SELECT
          initiator_id invitee,
          MAX(triggered_at) time_zero
        FROM events
        WHERE name @> ARRAY['user', 'invited']::VARCHAR[]
        GROUP BY invitee
      ) SELECT
          invited.invitee invitee,
          events.initiator_id inviter,
          invited.time_zero
        FROM events
          INNER JOIN invited ON events.target_id = invited.invitee
        WHERE
          name @> ARRAY['user', 'invitation_sent']::VARCHAR[] AND
          EXTRACT(EPOCH FROM events.triggered_at - invited.time_zero) < 1
      #{recent_only_query_part}
      #{pagination_query_part}
    SQL
  end
end
