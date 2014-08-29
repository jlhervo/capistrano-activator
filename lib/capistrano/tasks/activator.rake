require 'capistrano/activator/helpers'
require 'capistrano/dsl/activator_paths'
require 'capistrano/activator/rvm'

include Capistrano::Activator::Helpers
include Capistrano::DSL::ActivatorPaths

# TODO document !
# TODO templated default environment file (with JAVA_OPTS and JDBC_URI)
# TODO rbenv support
# TODO Logrotate support
# TODO Monit support
# TODO SSL support
# TODO check rollback support
# TODO no downtime deploy using 2 instances load balanced

namespace :load do
  task :defaults do
    set :activator_app_name, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

    set :activator_config_file, -> { "conf/#{fetch(:stage)}.conf" }
    set :activator_env_file, -> { ".env.#{fetch(:stage)}" }
    set :activator_apply_evolutions, false
    set :activator_db_name, 'default'
    set :activator_http_port, 9000
    set :activator_http_address, '127.0.0.1'
    set :activator_assets_compiler, 'Trireme'

    set :templates_path, 'conf/deploy/templates'
    set :linked_dirs,   fetch(:linked_dirs, []).push('logs', 'pids')
    set :linked_files,  fetch(:linked_files, []).push(".env", 'Procfile')

    # Ruby environment
    set :ruby_version, '2.1.2'
    set :rvm_path, '/usr/local/rvm'

    # Nginx configuration
    set :nginx_enabled, false
    set :nginx_path, '/etc/nginx'
  end
end

namespace :activator do

  def ruby
    # TODO find a better way to access rvm/rbenv sudo gems
    @ruby ||= Capistrano::Activator::RVM.new(self, fetch(:ruby_env_strategy, Capistrano::Activator::RVM::DefaultStrategy))
  end

  task :setup_config do
    on roles :app do
      # upload configuration file
      execute :mkdir, '-pv', activator_config_path
      upload! fetch(:activator_config_file), activator_config_file_path
    end
  end

  task :setup_logger do
    on roles :app do
      # upload logger configuration file
      exucute :mkdir, '-pv', activator_logs_path
      upload! template('logger_conf.erb'), activator_log_config_file_path
    end
  end

  task :setup_foreman do
    on roles :app do
      # upload Procfile
      upload! template('Procfile.erb'), activator_procfile_path

      # upload env file
      upload! "#{fetch(:activator_env_file)}", activator_envfile_path
    end
  end

  task :export_foreman do
    on roles :app do
      ruby.sudo_execute!("foreman export upstart /etc/init -a #{fetch(:activator_app_name)} -u #{host.user} -p #{fetch(:activator_http_port)}")
    end
  end
  after 'deploy:updated', 'activator:export_foreman'

  # TODO find a way to make execute working using sshkit
  task :stage do
    on roles :app do
      execute [
        "cd #{fetch(:release_path)}",
        "export SBT_OPTS=-Dsbt.jse.engineType=#{fetch(:activator_assets_compiler)}",
        "activator clean stage"
      ].join(' && ')
    end
  end
  after  'deploy:updated', 'activator:stage'

  task :restart do
    on roles(:web) do
      execute  "sudo start #{fetch(:activator_app_name)} || sudo restart #{fetch(:activator_app_name)}"
    end
  end
  after 'deploy:publishing', 'activator:restart'

  task :start do
    on roles(:web) do
      execute  :sudo, "start #{fetch(:activator_app_name)}"
    end
  end

  task :stop do
    on roles(:web) do
      execute :sudo, "stop #{fetch(:activator_app_name)}"
    end
  end

end

task :setup do
  invoke 'activator:setup_config'
  invoke 'activator:setup_logger'
  invoke 'activator:setup_foreman'

  # Loading plugins
  load File.expand_path('../nginx.rake', __FILE__) if fetch(:nginx_enabled)
end
