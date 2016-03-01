class Fetch
  class UnknownClass   < StandardError; end
  class InvalidOptions < StandardError
    attr_accessor :errors

    def initialize(message, errors)
      super(message)
      self.errors = errors
    end
  end

  attr_reader :entity, :options, :prefix, :name

  def initialize(entity, prefix, name, options = {})
    @entity, @prefix, @name, @options = [entity, prefix, name, options]
  end

  def do
    klass_parts = [entity, prefix, name]
    instance = Classifier.as_klass(*klass_parts).new(options)
    instance.valid? ? instance.execute : raise(InvalidOptions.new('invalid options', instance.errors.messages))
  rescue NameError
    raise UnknownClass, "#{Classifier.as_string(*klass_parts)} class not found"
  end
end
