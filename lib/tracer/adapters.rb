module Tracer
  module Adapters
    class Base
      def fetch_callers(mod, method_name)
        raise NotImplementedError, "#{self.class} is a base class that you must inherit to use"
      end

      def fetch_traces(mod)
        raise NotImplementedError, "#{self.class} is a base class that you must inherit to use"
      end

      def fetch_traced_callers(mod)
        raise NotImplementedError, "#{self.class} is a base class that you must inherit to use"
      end

      def store_caller(mod, method_name, calling_line)
        raise NotImplementedError, "#{self.class} is a base class that you must inherit to use"
      end
    end

    autoload :Redis, 'tracer/adapters/redis'
  end
end
