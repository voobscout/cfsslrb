module Cfsslrb
  module CLI
    class CaInitCommand < AbstractCommand
      using Corefines::String::Color

      def execute
        super
        @cfg = directory + '/cfssl_config.yml'
        (new? || force?) ? mk : LOGGER.error("#{@cfg} exists and no --force flag given!")
      end

      def new?
        !Pathname.new(@cfg).expand_path.exist?
      end

      def mk
        LOGGER.debug "Overwriting #{@cfg}" if force?
        FileUtils.mkdir_p directory
        FileUtils.cp(TEMPL8, @cfg)
        LOGGER.debug "Created #{@cfg}"
        puts "Success!\nEdit #{@cfg.color(:white)} before proceeding!"
      end
    end
  end
end
