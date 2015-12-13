module Shelldon
  class ConfigFactory

    def self.create(shell, &block)
      ConfigFactory.new(shell, &block)
    end

    def initialize(shell, &block)
      @shell = shell
      @config = Shelldon::Config.new
      self.instance_eval(&block)
      @shell.config = @config
    end

    private

    def config_file(filepath)
      filepath                    = Pathname.new(filepath)
      @config.config_file_handler = Shelldon::ConfigFileHandler.new(filepath)
    end

    def param(name, &block)
      ParamFactory.create(@config, name, &block)
    end

    def on_opt(opt, &block)
      if @config.on_opts.has_key(opt)
        @config.on_opts[opt] << block
      else
        @config.on_opts[opt] = [block]
      end
    end

    def timeout(i)
      param :timeout do
        type :number
        default i
        pretty { Time.at(val).utc.strftime("%H:%M:%S") }
      end
    end


  end
end