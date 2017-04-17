module Cfsslrb
  module CLI
    class CertCommand < AbstractCommand
      subcommand "create", 'Create new cert', CertCreateCommand
    end
  end
end
