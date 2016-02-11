class Users::Prefix
  class SampleQuery
    include ActiveModel::Validations
    validate :is_valid?

    def initialize(options)
      @is_valid = options[:is_valid]
    end

    def execute
      { result: :success }
    end

    def is_valid?
      errors.add :is_valid, 'is not valid' unless @is_valid
    end
  end
end
