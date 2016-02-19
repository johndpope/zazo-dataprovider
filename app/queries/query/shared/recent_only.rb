module Query::Shared::RecentOnly
  DEFAULT_RECENT_PERIOD = 2.weeks.ago.to_s

  def self.included(base)
    base.extend  ClassMethods
    base.include InstanceMethods

    base.class_eval do
      after_initialize :set_recent_only_options
    end
  end

  module ClassMethods
    def recent_only_settings(settings = nil)
      @settings = settings if settings.kind_of? Hash
      @settings
    end
  end

  module InstanceMethods
    private

    def set_recent_only_options
      @recent = !!options[:recent] || false
    end

    def recent_only_settings
      self.class.recent_only_settings
    end

    def recent_only_query_part
      return '' unless @recent && recent_only_settings[:column]
      start_with = recent_only_settings[:append] ? ' AND' : 'WHERE'
      "#{start_with} #{recent_only_settings[:column]} > '#{DEFAULT_RECENT_PERIOD}'"
    end
  end
end
