class Users::Queries::Attributes::VerifiedAt < Users::Queries::Attributes::Base
  def value
    event = Event.by_initiator('user', user.mkey).name_overlap('verified').first
    event && event.created_at.to_time
  end
end
