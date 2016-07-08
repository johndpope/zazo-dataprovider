class Users::Queries::Attributes < Query::Base
  ALLOWED_ATTRS = %i(id mkey auth status first_name last_name mobile_number device_platform emails country friends active_friends verified_at)

  attr_accessor :user, :users, :attrs
  validates :attrs, presence: true
  validate :user_or_users_are_presented?, :attrs_allowed?

  after_initialize :set_options

  def execute
    user ? attrs_by_user(user) : users.map { |u| attrs_by_user(u) }
  end

  private

  def attrs_by_user(user)
    attrs.each_with_object({}) do |attr, memo|
      memo[attr] = user.respond_to?(attr) ? user.send(attr) : external_attribute(user, attr)
    end
  end

  def external_attribute(user, attr)
    klass = Classifier.as_klass(self.class.name, attr)
    users && klass.collection_supported? ?
      external_attribute_from_collection(user, attr, klass) : klass.new(user).value
  end

  def external_attribute_from_collection(user, attr, klass)
    @cache[attr] = klass.new(users, as_collection: true).value unless @cache[attr]
    @cache[attr][user.mkey]
  end

  def set_options
    @user  = User.find_by(mkey: options[:user]) if options[:user]
    @users = User.where(mkey: options[:users]) if options[:users]
    @attrs = Array.wrap(options[:attrs])
    @cache = {}
  end

  #
  # custom validators
  #

  def user_or_users_are_presented?
    errors.add(:user, 'can\'t be blank') unless user || users
  end

  def attrs_allowed?
    attrs.each do |attr|
      errors.add(:attrs, "attr '#{attr}' is not allowed") unless ALLOWED_ATTRS.include?(attr.to_sym)
    end
  end
end
