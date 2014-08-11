module Capistrano
  module Activator
    module HelperMethods

      def template(from, to)
        template_path = File.expand_path("../../templates/#{from}", __FILE__)
        template = ERB.new(File.new(template_path).read).result(binding)
        upload! StringIO.new(template), to

        execute :chmod, "644 #{to}"
      end

      def activator_start_script
        shared_path.join("scripts/#{fetch(:application)}_start")
      end

      def activator_stage_script
        shared_path.join("scripts/#{fetch(:application)}_stage")
      end

      def activator_stage_path
        current_path.join('target/universal/stage/bin')
      end

      def activator_config_path
        shared_path.join('conf')
      end

      def activator_pid_path
        shared_path.join("pids/#{fetch(:application)}.pid")
      end

      def activator_config_file_exists?
        File.exists?("#{fetch(:activator_config_file)}")
      end

      def activator_config_file_path
        shared_path.join("#{fetch(:activator_config_file)}")
      end

      def activator_logger_file_exists?
        File.exists?("#{fetch(:activator_logger_file)}")
      end

      def activator_logger_file_path
        shared_path.join("#{fetch(:activator_logger_file)}")
      end

    end
  end
end
