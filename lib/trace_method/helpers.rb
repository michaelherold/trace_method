# frozen_string_literal: true

module TraceMethod
  module Helpers
    def trace_methods(*methods)
      add_traces_for(self, methods)
    end
    alias trace_method trace_methods

    def trace_singleton_methods(*methods)
      add_traces_for(singleton_class, methods)
    end
    alias trace_singleton_method trace_singleton_methods

    def traces
      __adapter__.traces(name)
    end

    def traced_callers
      __adapter__.traced_callers(name)
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

    def add_traces_for(base, methods)
      raise UnspecifiedMethods, 'You must give at least one method to trace' if methods.empty?

      if (mod = base.ancestors.find(&:__trace_method__?))
        Module.define_methods_on(mod, *methods)
      else
        base.prepend Module.new(*methods)
      end
    end
  end
end
