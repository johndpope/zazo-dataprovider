module Query::Shared::Pagination
  DEFAULT_PER_PAGE = 50

  def self.included(base)
    base.extend  ClassMethods
    base.include InstanceMethods

    base.class_eval do
      after_initialize :set_pagination_options
    end
  end

  module ClassMethods
  end

  module InstanceMethods
    private

    def set_pagination_options
      @page     = options[:page]
      @per_page = options[:per_page] || DEFAULT_PER_PAGE
    end

    def pagination_query_part
      return '' unless @page
      "LIMIT #{@per_page} OFFSET #{@per_page * (@page - 1)}"
    end
  end
end
