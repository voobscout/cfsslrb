module Cfsslrb
  module CLI
    class CaCommand < AbstractCommand
      subcommand "init", 'Manipulate CA', CaInitCommand
      subcommand "create", 'Manipulate CA', CaCreateCommand
    end
  end
end
