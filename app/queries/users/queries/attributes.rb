class Users::Queries::Attributes < Query::Base
  ALLOWED_ATTRS = %i(id mkey status first_name last_name email mobile_number device_platform)

  attr_accessor :user, :attrs
  validates     :user, :attrs, presence: true
  validate      :attrs_allowed?

  after_initialize :set_options

  def execute
    attrs.each_with_object({}) { |attr, memo| memo[attr] = user.send attr }
  end

  private

  def set_options
    @user  = User.find_by mkey: options[:user]
    @attrs = Array.wrap options[:attrs]
  end

  def attrs_allowed?
    attrs.each do |attr|
      errors.add :attrs, "attr '#{attr}' is not allowed" unless ALLOWED_ATTRS.include?(attr.to_sym)
    end
  end
end
