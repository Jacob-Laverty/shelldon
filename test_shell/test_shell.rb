require 'shelldon'
require 'pp'
Shelldon.shell do
  opts { opt '--debug', '-d', :boolean }

  scripts '~/test/test-scripts'

  command :test2 do
    action {}
    scripts '~/test/scripts2'
  end

  config do
    config_file '.shelldon_config'
    param :debug_mode do
      type :boolean
      default false
      opt 'd'
    end

    param :value do
      type :string
      default 'This is the default value!'
    end
  end

  command_missing do
    action { |cmd| puts "No such command \"#{cmd}\"" }
  end

  command :arg do
    help 'Show your args off!'
    action { |args| puts args }
  end

  command :blah do
    action { puts config[:value] }
    subcommand :swag do
      action { puts 'SWIGGITY SWAG!!!!' }
    end
  end

  command :help do
    action { |args| pp command_list.help(args) }
    help 'Show help. Optionally specify specific command for more information.'
    usage 'help [cmd]'
    examples ['help', 'help quit']
  end

  command :config do
    help 'Show the configuration of the current session.'
    usage 'config'
    action do |args|
      if args.empty?
        pp config.to_a
      else
        param = config.find(args.to_sym)
        puts "#{param.name}: #{param.val}"
      end
    end

    subcommand :save do
      help 'Save your current configuration'
      usage 'config save'
      action { config.save }
    end
  end

  command :set do
    help 'Set a configuration option for the remainder of the session.'

    action do |args|
      tokens                   = args.split(' ')
      config[tokens[0].to_sym] = tokens[1]
    end
  end

  shell do
    prompt 'shelldon> '
    home '~/.shelldon-test'
    history true
    history_file '.shelldon-history'

    errors do
      accept StandardError
      # accept(Interrupt) { puts '^C' }
    end
  end
end
