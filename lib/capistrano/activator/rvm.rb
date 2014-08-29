require 'sshkit'
require 'capistrano/activator/ruby'

module Capistrano
  module Activator
    class RVM < Capistrano::Activator::Ruby

      def rvm_sudo(*args)
        args.unshift("#{fetch(:ruby_version)} do rvmsudo")
        c = SSHKit::Command.new(:rvm, *args, env: {path: "#{fetch(:rvm_path)}/bin:$PATH"}, in: "#{fetch(:release_path)}")
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
