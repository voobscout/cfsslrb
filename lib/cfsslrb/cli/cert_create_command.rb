module Cfsslrb
  module CLI
    class CertCreateCommand < AbstractCommand
      option ['-t', '--type'], 'TYPE', 'One of: [client, server, client-server]', required: true do |t|
        [t].grep(/^client$|^server$|^client-server$/).first ? t : signal_usage_error('TYPE must be one of [client, server, client-server]')
      end
      option '--key-algo', 'algo', 'rsa etc..', default: 'rsa'
      option '--key-size', 'keysize', 'Key size etc...', default: 2048
      option '--[no-]json-dump', :flag, 'Dump json files together with certs', default: false

      parameter 'CN', 'Common Name'
      parameter 'SAN ...', 'Subject Alternative Names(s)', attribute_name: :alt_names

      def execute
        super
        @cert_csr = cn + '-csr.json'
        @cert_pem = cn + '-pem.json'
        @cert_dir = (pn(directory) + 'clients' + cn).to_s
        (new? || force?) ? mk : LOGGER.error("Cert exist, --force not found!")
      end

      private
      def mk
        chdir(directory)
        @cert_csr_yaml = cfg['ssl']['node'].dup
        @cert_csr_yaml['CN'] = cn
        @cert_csr_yaml['hosts'] = alt_names
        @cert_csr_yaml['key']['algo'] = key_algo if key_algo
        @cert_csr_yaml['key']['size'] = key_size.to_i if key_size
        @cert_pem = sh('echo', "'#{@cert_csr_yaml.to_json}' | cfssl gencert #{params} -").run
        mk_files
      end

      def mk_files
        mkdir(@cert_dir)
        cert_bundle = sh('echo', "'#{@cert_pem}' | cfssljson -stdout -bare -f -").run.split("\n\n")
        (pn(@cert_dir) + 'cert.pem').write(cert_bundle[0] + "\n")
        (pn(@cert_dir) + 'cert-key.pem').write(cert_bundle[1] + "\n")
        (pn(@cert_dir) + 'cert.csr').write(cert_bundle[2] + "\n")

        if json_dump?
          (pn(@cert_dir) + (cn + '-csr.json')).write(@cert_csr_yaml.to_json)
          (pn(@cert_dir) + (cn + '-pem.json')).write(@cert_pem)
        end
      end

      def params
        (%w(-ca=ca.pem
           -ca-key=ca-key.pem
           -config=ca-config.json) << ('-profile=' + type)).join(' ')
      end

      def new?
        !(pn(@cert_dir) + 'cert-key.pem').exist?
      end
    end
  end
end
