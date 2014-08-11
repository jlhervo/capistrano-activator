require 'capistrano/activator/helper_methods'

include Capistrano::Activator::HelperMethods

namespace :load do
  task :defaults do
    set :activator_config_file, -> { "conf/#{fetch(:stage)}.conf" }
    set :activator_logger_file, -> { "conf/#{fetch(:stage)}_logger.xml" }
    set :activator_apply_evolutions, true
    set :activator_http_port, 9000
    set :activator_http_address, '0.0.0.0'
    set :activator_mem, '1024'
  end
end

namespace :activator do

  task :copy_scripts do
    on roles :app do
      execute :mkdir, '-pv', shared_path.join('scripts') unless test "[ -e #{activator_start_script} ]"
      template "activator_start.erb", activator_start_script
      execute :chmod, "+x #{activator_start_script}"
      template "activator_stage.erb", activator_stage_script
      execute :chmod, "+x #{activator_stage_script}"
    end
  end

  task :copy_config do
    # Configuration file is mandatory
    unless activator_config_file_exists?
      error 'Configuration file not found!'
      exit 1
    end

    on roles :app do
      execute :mkdir, '-pv', activator_config_path unless test "[ -e #{activator_config_path} ]"

      upload! fetch(:activator_config_file), activator_config_file_path
      upload! fetch(:activator_logger_file), activator_logger_file_path if activator_logger_file_exists?
    end
  end

  task :stage do
    on roles :app do
      within current_path do
        execute activator_stage_script
      end
    end
  end
  after  'deploy:published', 'activator:stage'

  task :start do
    on roles :app do
      within activator_stage_path do
        execute activator_start_script
      end
    end
  end

  task :stop do
    on roles :app do
      if test("[ -f #{shared_path}/pids/#{fetch(:application)}.pid ]")
        execute :kill, capture(:cat, "#{shared_path}/pids/#{fetch(:application)}.pid")
      else
        error 'No Play! application currently running!'
      end
    end
  end

  task :restart do
    invoke 'activator:stop'
    invoke 'activator:start'
  end

end

task :setup do
  invoke 'activator:copy_scripts'
  invoke 'activator:copy_config'
end
