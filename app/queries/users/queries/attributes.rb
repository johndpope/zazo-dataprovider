class Users::Queries::Attributes < Query::Base
  ALLOWED_ATTRS = %i(id mkey auth status first_name last_name email mobile_number device_platform emails country friends active_friends)

  attr_accessor :user, :attrs
  validates     :user, :attrs, presence: true
  validate      :attrs_allowed?

  after_initialize :set_options

  def execute
    attrs.each_with_object({}) do |attr, memo|
      memo[attr] = user.respond_to?(attr) ?
        user.send(attr) : Classifier.as_klass(self.class.name, attr).new(user).value
    end
  end

  private

  def set_options
    @user  = User.find_by(mkey: options[:user])
    @attrs = Array.wrap(options[:attrs])
  end

  def attrs_allowed?
    attrs.each do |attr|
      errors.add(:attrs, "attr '#{attr}' is not allowed") unless ALLOWED_ATTRS.include?(attr.to_sym)
    end
  end
end
