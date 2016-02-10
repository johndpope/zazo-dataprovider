class Fetch
  class UnknownClass   < StandardError; end
  class InvalidOptions < StandardError; end

  attr_reader :options, :prefix, :name

  def initialize(prefix, name, options = {})
    @prefix, @name, @options = [prefix, name, options]
  end

  def do
    instance = Classifier.as_klass(:fetch, prefix, name).new(options)
    instance.valid? ? instance.execute : fail(InvalidOptions, instance.errors.messages)
  rescue NameError
    raise UnknownClass, "#{Classifier.as_string(prefix, name)} class not found"
  end
end
