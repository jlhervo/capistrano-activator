module Capistrano
  module DSL
    module ActivatorPaths

      def activator_config_path
        shared_path.join('conf')
      end

      def activator_procfile_path
        shared_path.join('Procfile')
      end

      def activator_envfile_path
        shared_path.join('.env')
      end

      def activator_pid_path
        shared_path.join("pids/#{:activator_app_name}.pid")
      end

      def activator_config_file_path
        activator_config_path.join("#{fetch(:stage)}.conf")
      end

      def activator_logs_path
        shared_path.join('logs')
      end

      def activator_log_config_file_path
        activator_config_path.join('logger.xml')
      end

      def activator_bin_file
        current_path.join("target/universal/stage/bin/#{fetch(:application)}")
      end

    end
  end
end
