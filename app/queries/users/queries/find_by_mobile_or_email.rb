class Users::Queries::FindByMobileOrEmail < Query::Base
  attr_reader :email, :mobile

  after_initialize :set_options

  def execute
    user = nil
    user = User.where(mobile_number: mobile).first if mobile
    user = User.where('emails LIKE ?', "%#{email}%").first if !user && email
    { id: user.try(:id), mkey: user.try(:mkey) }
  end

  private

  def set_options
    @email  = options['email']
    @mobile = options['mobile']
  end
end
