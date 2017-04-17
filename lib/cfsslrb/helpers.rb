module Cfsslrb
  module Helpers
    def pn(fname)
      Pathname.new(fname)
    end

    def chdir(dir)
      FileUtils.cd(dir)
    end

    def mv(src, dst)
      FileUtils.mv(src, dst)
    end

    def mkdir(dirname)
      FileUtils.mkdir_p(dirname)
    end

    def sh(bin, opts)
      Cocaine::CommandLine.new(bin, opts)
    end

    def cfg
      YAML.load_file(directory + '/cfssl_config.yml')
    end
  end # Helpers
end
