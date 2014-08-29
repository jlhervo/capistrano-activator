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

      def assets_compiler_exists?(compiler)
        ['Node', 'PhantomJs', 'Rhino', 'Trireme'].include? compiler
      end

    end
  end
end
