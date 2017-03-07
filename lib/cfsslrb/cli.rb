module Cfsslrb
  # class Ca
  class Ca < Thor
    desc 'init </ca/folder/path>', 'initialize dir with example template yml'
    def init(dir)
      dir = Pathname.new(dir).expand_path.to_s
      tmpl8 = (Pathname.new(__FILE__).dirname.parent + 'cfssl_template.yml').to_s
      fname = dir + '/cfssl_config.yml'
      FileUtils.mkdir_p dir
      FileUtils.cp(tmpl8, fname)
      say (set_color 'Edit', :red, :bold) + ' ' + (set_color fname, :cyan) + ' before proceeding'
    end

    desc 'create </ca/folder/path>', 'create new CA in specified folder'
    def create(dir)
      @ca_dir = Pathname.new(dir).expand_path.to_s
      raise ArgumentError('existing CA at ' + dir.to_s) if existing_ca?
      @config = YAML.load_file(@ca_dir + '/cfssl_config.yml')
      tmpdir = Dir.mktmpdir
      FileUtils.cd(tmpdir)
      IO.write((tmpdir + '/ca-config.json'), @config['ssl']['config'].to_json)
      IO.write((tmpdir + '/ca-csr.json'), @config['ssl']['ca'].to_json)
      ca_json = Cocaine::CommandLine.new('cfssl', 'gencert -initca ca-csr.json').run
      IO.write((tmpdir + '/ca.json'), ca_json)
      Cocaine::CommandLine.new('cfssljson', '-bare -f ca.json').run
      FileUtils.cp_r((tmpdir + '/.'), @ca_dir)
      FileUtils.mv("#{@ca_dir}/cert-key.pem", "#{@ca_dir}/ca-key.pem")
      FileUtils.mv("#{@ca_dir}/cert.pem", "#{@ca_dir}/ca.pem")
      FileUtils.mv("#{@ca_dir}/cert.csr", "#{@ca_dir}/ca.csr")

    ensure
      FileUtils.rm_rf(tmpdir)
    end

    no_commands do
      def existing_ca?
        files = %w(ca.csr
                   ca-config.json
                   ca-csr.json
                   ca.json
                   ca-key.pem
                   ca.pem).map { |f| Pathname.new(@ca_dir + '/' + f) }
        true unless files.map(&:exist?).include?(false)
      end
    end
  end

  # class Client
  class Client < Thor
    desc 'add [name]', 'generate keys for client profile'
    def add(name)
      @ca_dir = FileUtils.pwd
      @config = YAML.load_file(@ca_dir + '/cfssl_config.yml')
      @client_csr = @config['ssl']['node'].dup
      FileUtils.cd(@ca_dir)
      @client_csr['CN'] = name
      client_csr = name + '-csr.json'
      client_pem = name + '-pem.json'
      IO.write(client_csr, @client_csr.to_json)
      params = %w(-ca=ca.pem
                  -ca-key=ca-key.pem
                  -config=ca-config.json
                  -profile=client).join(' ')
      IO.write(client_pem, Cocaine::CommandLine.new('cfssl', "gencert #{params} #{client_csr}").run)
      Cocaine::CommandLine.new('cfssljson', "-bare -f #{client_pem}").run
      out_dir = "#{@ca_dir}/clients/#{name}"
      FileUtils.mkdir_p(out_dir)
      ([client_csr, client_pem] + %w(cert-key.pem
                                     cert.pem
                                     cert.csr)).each{ |f| FileUtils.mv(f, out_dir) }
    end
  end


  class Cli < Thor
    desc 'ca SUBCOMMAND ...ARGS', 'CA crud'
    subcommand "ca", Ca

    desc 'client SUBCOMMAND ...ARGS', 'client certs crud...'
    subcommand 'client', Client
  end # Cli
end
