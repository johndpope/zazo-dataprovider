class Users::Queries::MutualFriends < Query::Base
  include Query::Shared::RunRawQuery

  attr_reader :user_id, :contact_id, :user_mkey, :contact_mkey
  validates   :user_id, :contact_id, presence: true

  after_initialize :set_options

  def execute
    run_raw_query_on_connections(query).each_with_object(Set.new) do |res, set|
      set.merge [res['creator'], res['target']]
    end.delete(contact_mkey).to_a
  end

  private

  def query
    sql = <<-SQL
      SELECT
        by_creator.mkey creator,
        by_target.mkey target
      FROM connections
        JOIN users by_creator ON by_creator.id = creator_id
        JOIN users by_target ON by_target.id = target_id
      WHERE (creator_id IN (?) OR target_id IN (?)) AND
            (creator_id = ? OR target_id = ?)
    SQL
    Connection.send :sanitize_sql_array, [sql, friends_ids, friends_ids, contact_id, contact_id]
  end

  def friends_ids
    return @friends_ids if @friends_ids
    connections = User.find(user_id).connections.includes(:target, :creator)
    @friends_ids = connections.each_with_object(Set.new) do |conn, set|
      set.merge [conn.target_id, conn.creator_id]
    end.delete(user_id).delete(contact_id).to_a
  end

  def set_options
    @user_mkey    = options['user_mkey']
    @contact_mkey = options['contact_mkey']
    @user_id    = User.find_by_mkey(user_mkey).try(:id)
    @contact_id = User.find_by_mkey(contact_mkey).try(:id)
  end
end
