class Users::Filters::RecentlyJoined < Query::Base
  DEFAULT_TIME_FRAME = 10.years
  ALLOWED_ATTRIBUTES = %i(id mkey mobile_number first_name last_name emails status)

  attr_accessor :time_frame_in_days, :recent_time_frame

  after_initialize :set_options

  def execute
    User.where('created_at > ?', Time.now - recent_time_frame).map do |u|
      ALLOWED_ATTRIBUTES.each_with_object({}) { |attr, memo| memo[attr] = u.send attr }
    end
  end

  private

  def set_options
    @time_frame_in_days = options['time_frame_in_days']
    @recent_time_frame  = time_frame_in_days ? time_frame_in_days.to_i.days : DEFAULT_TIME_FRAME
  end
end
