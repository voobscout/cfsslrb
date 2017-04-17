module Cfsslrb
  module CLI
    #
    class AbstractCommand < Clamp::Command
      include Cfsslrb::Helpers

      option ['-f', '--force'], :flag, 'Force overwrite', default: false
      option ['-d', '--directory'], 'DIRECTORY', 'Filesystem path to CA folder', default: Pathname.new('.').expand_path.to_s
      option ['-l', '--loglevel'], 'LOGLEVEL', 'debug < info < warn < error < fatal < unknown', default: 'info'

      def execute
        LOGGER.level = loglevel.to_sym
        LOGGER.progname = self.class.name + '#' + __callee__.to_s
      end
    end
  end
end
