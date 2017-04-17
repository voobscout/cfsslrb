module Cfsslrb
  module CLI
    class CaCreateCommand < AbstractCommand
      def execute
        super
        (new? || force?) ? mk : LOGGER.error("CA exists, --force not found!")
      end

      def mk
        # binding.pry
        chdir(directory)
        pn('ca-config.json').write(cfg['ssl']['config'].to_json)
        pn('ca-csr.json').write(cfg['ssl']['ca'].to_json)
        ca_json = sh('cfssl', 'gencert -initca ca-csr.json').run
        pn('ca.json').write(ca_json)
        # create CA
        sh('cfssljson', '-bare -f ca.json').run
        # rename files
        mv('cert-key.pem', 'ca-key.pem')
        mv('cert.pem', 'ca.pem')
        mv('cert.csr', 'ca.csr')
      end

      private
      def new?
        %w(cfssl_config.yml
           ca.csr
           ca-config.json
           ca-csr.json
           ca.json
           ca-key.pem
           ca.pem).map do |f|
          Pathname.new(directory + '/' + f).exist?
        end.include?(false)
      end
    end
  end
end
