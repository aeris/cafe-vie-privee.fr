require 'middleman-deploy/methods/base.rb'

module Middleman
  module Deploy
    module Methods
      class RsyncLocal < Base
        attr_reader :clean, :flags, :path

        def initialize(server_instance, options = {})
          super(server_instance, options)

          @clean  = self.options.clean
          @flags  = self.options.flags
          @path   = self.options.path
        end

        def process
          flags     = self.flags || '-ahvxP'
          command   = "rsync #{flags} #{self.server_instance.build_dir}/ #{path}/"
          command += ' --delete' if clean
          puts "## Deploying via rsync to #{path}"
          exec command
        end
      end
    end
  end
end
