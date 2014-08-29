require 'capistrano/dsl/nginx_paths'

include Capistrano::DSL::NginxPaths

namespace :nginx do

  task :setup do
    on roles(:web) do
      next if file_exists? nginx_sites_available_file

      # upload generated site file
      upload! template('nginx_conf.erb'), nginx_temp_conf_path

      # alias it to sites-enabled
      execute :sudo, :mv, nginx_temp_conf_path, nginx_sites_available_file
      execute :sudo, :ln, '-fs', nginx_sites_available_file, nginx_sites_enabled_file
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
end
