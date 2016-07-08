class Users::Queries::Attributes::VerifiedAt < Users::Queries::Attributes::Base
  collection

  def value
    collection_enabled? ? handle_collection : handle_user
  end

  private

  def handle_user
    event = Event.by_initiator('user', user.mkey).name_overlap('verified').first
    event && event.triggered_at.to_time
  end

  def handle_collection
    events = Event.by_initiator('user', users.map(&:mkey)).name_overlap('verified')
    events.each_with_object({}) do |event, memo|
      memo[event.initiator_id] = event.triggered_at.to_time unless memo[event.initiator_id]
    end
  end
end
