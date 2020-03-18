# frozen_string_literal: true

module TraceMethod
  module Helpers
    def callers_of(method)
      __adapter__.callers(name, method)
    end

    def trace_methods(*methods)
      Trace.add_to(self, methods)
    end
    alias trace_method trace_methods

    def trace_singleton_methods(*methods)
      Trace.add_to(singleton_class, methods)
    end
    alias trace_singleton_method trace_singleton_methods

    def traces
      __adapter__.traces(name)
    end

    def traced_callers
      __adapter__.traced_callers(name)
    end

    def singleton_callers_of(method)
      name = NameExtractor.call(self)
      __adapter__.callers(name, method)
    end

    def singleton_traces
      name = NameExtractor.call(self)
      __adapter__.traces(name)
    end

    def singleton_traced_callers
      name = NameExtractor.call(self)
      __adapter__.traced_callers(name)
    end

    private

    def __adapter__
      @__adapter__ ||= TraceMethod.config.adapter
    end
  end
end
