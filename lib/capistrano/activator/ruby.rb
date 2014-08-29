module Capistrano
  module Activator
    class Ruby
      attr_reader :context

      def initialize(context, strategy)
        @context = context
        singleton = class << self; self; end
        singleton.send(:include, strategy)
      end

      def sudo_execute!(*args)
        raise NotImplementedError.new(
          "Your Ruby environment strategy module should provide a #sudo_execute! method"
        )
      end

    end
  end
end
