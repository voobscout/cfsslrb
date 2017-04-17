require 'clamp'
require 'pry'

module MyBin
  # class AC
  class AbstractCommand < Clamp::Command
    option ['-v', '--verbose'], :flag, 'be verbose'

    option '--version', :flag, 'show version' do
      puts 'MyBin v0.0.1'
      exit(0)
    end

    def say(message)
      message = message.upcase if verbose?
      puts message
    end
  end
  # docu
  class CloneCommand < AbstractCommand
    parameter 'REPOSITORY', 'repository to clone'
    parameter '[DIR]', 'working directory', default: '.'

    def execute
      say "cloning to #{dir}"
    end
  end
  # docu
  class PullCommand < AbstractCommand
    option '--[no-]commit', :flag, 'Perform the merge and commit the result.'

    def execute
      say 'pulling'
    end
  end
  # docu
  class SuperStatusCommand < AbstractCommand
    # option ['-s', '--short'], :flag, 'Give the output in the short-format.'
    option ['-n', '--name'], 'NAME', 'option description', multivalued: true
    parameter '[HOST]', 'server address', environment_variable: 'MYAPP_HOST'
    parameter '[SAN] ...', 'Subject Alternative Names', attribute_name: :alt_names

    def execute
      say(name_list.join(',') + ' | ' + alt_names.join(','))
      say(host)
    end

    def some
      puts 'yo!'
    end
  end
  # docu
  class StatusCommand < AbstractCommand
    option ['-s', '--short'], :flag, 'Give the output in the short-format.'

    def execute
      if short?
        say 'good'
      else
        say 'its all good ...'
      end
    end
    subcommand 'superstatus', 'get a superstatus', SuperStatusCommand
  end
  # docu
  class MainCommand < AbstractCommand
    subcommand 'clone', 'Clone a remote repository.', CloneCommand
    subcommand 'pull', 'Fetch and merge updates.', PullCommand
    subcommand 'status', 'Display status of local repository.', StatusCommand
  end
end

MyBin::MainCommand.run
