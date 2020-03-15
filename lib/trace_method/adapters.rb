# frozen_string_literal: true

module TraceMethod
  module Adapters
    class Base
      def clear
        raise NotImplementedError, "#{self.class} is a base class that you must inherit to use"
      end

      def callers(_mod, _method_name)
        raise NotImplementedError, "#{self.class} is a base class that you must inherit to use"
      end

      def traces(_mod)
        raise NotImplementedError, "#{self.class} is a base class that you must inherit to use"
      end

      def traced_callers(_mod)
        raise NotImplementedError, "#{self.class} is a base class that you must inherit to use"
      end

      def modules
        raise NotImplementedError, "#{self.class} is a base class that you must inherit to use"
      end

      def add_caller(_mod, _method_name, _calling_line)
        raise NotImplementedError, "#{self.class} is a base class that you must inherit to use"
      end
    end

    autoload :Redis, 'trace_method/adapters/redis'
  end
end
