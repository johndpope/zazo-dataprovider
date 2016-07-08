require 'awesome_print'
AwesomePrint.pry! if defined?(AwesomePrint)

if defined?(Hirb)
  Hirb::View.instance_eval do
    def enable_output_method
      @output_method = true
      @old_print = Pry.config.print
      Pry.config.print = proc do |*args|
        Hirb::View.view_or_page_output(args[1]) || @old_print.call(*args)
      end
    end

    def disable_output_method
      Pry.config.print = @old_print
      @output_method = nil
    end
  end
  extend Hirb::Console
end

if defined?(::Rails) && Rails.env
  unless Rails.application.config.console == ::Pry
    Rails.application.config.console = ::Pry
  end

  unless defined? ::Rails::ConsoleMethods
    require 'rails/console/app'
    require 'rails/console/helpers'
    TOPLEVEL_BINDING.eval('self').extend ::Rails::ConsoleMethods
  end
end
