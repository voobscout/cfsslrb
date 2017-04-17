module Cfsslrb
  # docu
  module CLI
    %w(abstract
       ca_init
       ca_create
       ca
       cert_create
       cert
       main).each{ |r| require_relative('cli/' + r + '_command') }
  end # CLI
end # cfssl

# def self.load_commands
#   this_file = Pathname.new(__FILE__).expand_path
#   commands_dir = this_file.dirname + this_file.basename.to_s.split('.rb').first
#   commands_dir.children.each do |req|
#     next unless req.basename.to_s =~ /.rb/
#     require req.to_s
#   end
# end
