require 'sshkit'
require 'capistrano/rvm'
require 'capistrano/activator/ruby'

module Capistrano
  module Activator
    class RVM < Capistrano::Activator::Ruby

      def rvm_sudo(*args)
        c = SSHKit::Command.new(:rvmsudo, *args, in: "#{fetch(:release_path)}")
        context.execute c.to_command
      end

      module DefaultStrategy
        def sudo_execute!(*args)
          rvm_sudo *args
        end
      end

    end
  end
end
