class Users::Queries::Attributes::Base
  class CollectionIsNotSupported < Exception; end

  attr_reader :user, :users

  class << self
    def collection(is_supported = true)
      @is_collection_supported = is_supported
    end

    def collection_supported?
      !!@is_collection_supported
    end
  end

  def initialize(object, as_collection: false)
    @is_collection_enabled = as_collection
    fail(CollectionIsNotSupported) if collection_enabled? && !self.class.collection_supported?
    collection_enabled? ? @users = object : @user = object
  end

  def collection_enabled?
    @is_collection_enabled
  end
end
