require 'erb'

module Capistrano
  module Activator
    module Helpers

      def template(template_name)
        config_file = "#{fetch(:templates_path)}/#{template_name}"
        # if no customized file, proceed with default
        unless File.exists?(config_file)
          config_file = File.join(File.dirname(__FILE__), "../../generators/capistrano/activator/templates/#{template_name}")
        end
        StringIO.new(ERB.new(File.read(config_file)).result(binding))
      end

      def file_exists?(path)
        test "[ -e #{path} ]"
      end

      def sudo_upload!(from, to)
        filename = File.basename(to)
        to_dir = File.dirname(to)
        tmp_file = "#{fetch(:tmp_dir)}/#{filename}"
        upload! from, tmp_file
        sudo :mv, tmp_file, to_dir
      end

      def assets_compiler_exists?(compiler)
        ['Node', 'PhantomJs', 'Rhino', 'Trireme'].include? compiler
      end

    end
  end
end
