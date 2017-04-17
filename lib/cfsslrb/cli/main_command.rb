module Cfsslrb
  module CLI
    class MainCommand < Clamp::Command
      option '--version', :flag, 'show version' do
        puts 'Cfsslrb v' + Cfsslrb::VERSION
        exit(0)
      end

      subcommand "ca", 'Manipulate CA', CaCommand
      subcommand 'cert', 'client cert crud', CertCommand
    end
  end
end
