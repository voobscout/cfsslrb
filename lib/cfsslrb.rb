%w(yaml
   json
   fileutils
   pathname
   logger
   corefines
   cocaine
   active_support/core_ext/kernel
   clamp).each(&method(:require))

# Silly deprecation warnings with ::Fixnum, ::Bignum used instead of ::Integer
module Corefines
  module String
    module Color
      private
      def self.color_code(color, offset)
        return color + offset if color.is_a? ::Integer
        COLOR_CODES[color.to_sym] + offset if color && COLOR_CODES[color.to_sym]
      end
      def self.mode_code(mode)
        return mode if mode.is_a? ::Integer
        MODE_CODES[mode.to_sym] if mode
      end
    end
  end
end

# module Cfsslrb
module Cfsslrb
  class CustomLogFormater < Logger::Formatter
    using Corefines::String::Color
    def self.call(severity, time, progname, msg)
      # :debug < :info < :warn < :error < :fatal < :unknown
      severity = case severity
                 when /debug/i then severity.color(:light_magenta)
                 when /info/i then severity.color(:cyan)
                 when /warn/i then severity.color(:yellow)
                 when /error/i then severity.color(:red)
                 when /fatal/i then severity.color(text: :red, mode: :bold)
                 else
                   severity.color(text: :white, mode: :bold)
                 end
      time = time.strftime('[' + "%H:%M:" + "%S".color(:white) + ']')
      progname = progname.split('::')
      progname = progname[0..-2].join('::'.color(:white)) + '::'.color(:white) + progname.last.split('#').first.color(fg: :light_magenta, bg: :black) + '#'.color(:white) + progname.last.split('#').last.color(:yellow)
      # progname = '' if (severity.color(mode: :default) =~ /info/i)
      puts "#{time} #{progname} [#{severity.rjust(20)}]: " + msg
    end
  end

  LOGGER = Logger.new($stdout,
                      formatter: Cfsslrb::CustomLogFormater)
  TEMPL8 = (Pathname.new(__FILE__).dirname.expand_path + 'cfssl_template.yml').to_s

  def self.logger
    LOGGER
  end
end

%w(cfsslrb/version
   cfsslrb/helpers
   cfsslrb/cli).each { |r| require((Pathname.new(__FILE__).expand_path.dirname + r).to_s) }
