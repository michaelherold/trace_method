module Tracer
  module Helpers
    def trace_methods(*methods)
      raise UnspecifiedMethods, 'You must give as least one method to trace' if methods.empty?

      prepend Tracer::Module.new(*methods)
    end
    alias trace_method trace_methods

    def traces
      __adapter__.fetch_traces(name)
    end

    def traced_callers
      __adapter__.fetch_traced_callers(name)
    end

    private

    def __adapter__
      @__adapter__ ||= Tracer.config.adapter
    end
  end
end
