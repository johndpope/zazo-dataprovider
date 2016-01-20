class Event < BaseConnection::EventsDb
  # legacy
  scope :since,                -> (time) { where('triggered_at >= ?', time) }
  scope :till,                 -> (time) { where('triggered_at <= ?', time) }
  scope :today,                -> { since Date.today }
  scope :top_namespace,        -> (namespace) { where 'name[1] = ?', namespace }
  scope :by_initiator,         -> (initiator, initiator_id) { where initiator: initiator, initiator_id: initiator_id }
  scope :by_target,            -> (target, target_id) { where target: target, target_id: target_id }
  scope :by_name,              -> (name) { where 'name = ARRAY[?]::varchar[]', name }
  scope :name_contains,        -> (part) { where 'name @> ARRAY[?]::varchar[]', part }
  scope :name_overlap,         -> (part) { where 'name && ARRAY[?]::varchar[]', part }
  scope :with_sender,          -> (user_id) { where "data->>'sender_id' = ?", user_id }
  scope :with_senders,         -> (user_ids) { where "data->>'sender_id' IN (?)", user_ids }
  scope :with_receiver,        -> (user_id) { where "data->>'receiver_id' = ?", user_id }
  scope :with_receivers,       -> (user_ids) { where "data->>'receiver_id' IN (?)", user_ids }
  scope :with_video_filename,  -> (video_filename) { where "data->>'video_filename' = ?", video_filename }
  scope :with_video_filenames, -> (video_filenames) { where "data->>'video_filename' IN (?)", video_filenames }
  scope :video_s3_uploaded,    -> { by_name %w(video s3 uploaded) }
  scope :s3_events,            -> { name_overlap %w(uploaded sent) }

  def self.filter_by(term)
    term = Array(term)
    term_pattern = "%(#{term.join('|')})%"
    where 'initiator_id IN (:term) OR target_id IN (:term) OR data::text SIMILAR TO :term_pattern',
          term: term, term_pattern: term_pattern
  end

  # new
  scope :status_transitions,   -> { name_overlap %w(invited initialized registered verified) }
  scope :invites,              -> { by_name %w(user invitation_sent) }
end
