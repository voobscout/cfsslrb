%w(yaml
   json
   fileutils
   pathname
   cocaine
   thor).each(&method(:require))

[
   'cfsslrb/version',
   'cfsslrb/cli'
].each { |r| require (Pathname.new(__FILE__).expand_path.dirname + r).to_s }

# module Cfsslrb
module Cfsslrb
  # Your code goes here...
end
