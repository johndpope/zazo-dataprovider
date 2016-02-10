class Classifier
  class << self
    def as_klass(*parts)
      as_string(*parts).constantize
    end

    def as_string(*parts)
      parts.compact.map(&:to_s).map(&:camelize).join '::'
    end
  end
end
