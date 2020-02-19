# frozen_string_literal: true

module TraceMethod
  module Helpers
    def trace_methods(*methods)
      raise UnspecifiedMethods, 'You must give at least one method to trace' if methods.empty?

      if (mod = ancestors.find(&:__trace_method__?))
        Module.define_methods_on(mod, *methods)
      else
        prepend Module.new(*methods)
      end
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
      @__adapter__ ||= TraceMethod.config.adapter
    end
  end
end
