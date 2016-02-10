class Query::Base
  extend ActiveModel::Callbacks
  include ActiveModel::Validations

  class OptionsWrapper < Hash
    include Hashie::Extensions::IndifferentAccess
  end

  attr_reader :options
  define_model_callbacks :initialize

  def initialize(options = {})
    run_callbacks :initialize do
      @options = OptionsWrapper[options || {}]
    end
  end
end
