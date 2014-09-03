module Capistrano
  module DSL
    module NginxPaths

      def nginx_sites_available_file
        "#{fetch(:nginx_path)}/sites-available/#{fetch(:activator_app_name)}"
      end

      def nginx_sites_enabled_file
        "#{fetch(:nginx_path)}/sites-enabled/#{fetch(:activator_app_name)}"
      end

      def nginx_default_ssl_cert_file_name
        "#{fetch(:activator_app_name)}.crt"
      end

      def nginx_default_ssl_cert_key_file_name
        "#{fetch(:activator_app_name)}.key"
      end

      def nginx_ssl_cert_file
        "/etc/ssl/certs/#{fetch(:nginx_ssl_cert)}"
      end

      def nginx_ssl_cert_key_file
        "/etc/ssl/private/#{fetch(:nginx_ssl_cert_key)}"
      end

    end
  end
end
