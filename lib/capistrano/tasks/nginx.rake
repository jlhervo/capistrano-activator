require 'capistrano/dsl/nginx_paths'

include Capistrano::DSL::NginxPaths

namespace :load do
  task :defaults do
    set :nginx_path, '/etc/nginx'
    set :nginx_use_ssl, false
    set :nginx_ssl_cert, -> { nginx_default_ssl_cert_file_name }
    set :nginx_ssl_cert_key, -> { nginx_default_ssl_cert_key_file_name }
    set :nginx_upload_local_cert, true
    set :nginx_ssl_cert_local_path, -> { ask(:nginx_ssl_cert_local_path, 'Local path to ssl certificate: ') }
    set :nginx_ssl_cert_key_local_path, -> { ask(:nginx_ssl_cert_key_local_path, 'Local path to ssl certificate key: ') }
  end
end

namespace :nginx do

  task :setup do
    on roles(:web) do
      next if file_exists? nginx_sites_available_file

      # upload generated site file
      sudo_upload! template('nginx_conf.erb'), nginx_sites_available_file

      # alias it to sites-enabled
      execute :sudo, :ln, '-fs', nginx_sites_available_file, nginx_sites_enabled_file
    end
  end

  task :setup_ssl do
    next unless fetch(:nginx_use_ssl)
    on roles(:web) do
      next if file_exists?(nginx_ssl_cert_file) && file_exists?(nginx_ssl_cert_key_file)
      if fetch(:nginx_upload_local_cert)
        sudo_upload! fetch(:nginx_ssl_cert_local_path), nginx_ssl_cert_file
        sudo_upload! fetch(:nginx_ssl_cert_key_local_path), nginx_ssl_cert_key_file
      end
      sudo :chown, 'root:root', nginx_ssl_cert_file
      sudo :chown, 'root:root', nginx_ssl_cert_key_file
    end
  end

  task :reload do
    on roles :web do
      execute :sudo, :service, 'nginx reload'
    end
  end
  after 'deploy:publishing', 'nginx:reload'

end

task :setup do
  invoke 'nginx:setup'
  invoke 'nginx:setup_ssl'
end
