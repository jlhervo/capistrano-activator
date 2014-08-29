module Capistrano
  module DSL
    module NginxPaths

      def nginx_sites_available_file
        "#{fetch(:nginx_path)}/sites-available/#{host}"
      end

      def nginx_sites_enabled_file
        "#{fetch(:nginx_path)}/sites-enabled/#{host}"
      end

      def nginx_temp_conf_path
        "/tmp/#{fetch(:activator_app_name)}-nginx.conf"
      end

    end
  end
end
