# frozen_string_literal: true

module TraceMethod
  module Trace
    def self.add_to(base, methods)
      raise UnspecifiedMethods, 'You must give at least one method to trace' if methods.empty?

      if (mod = base.ancestors.find(&:__trace_method__?))
        Module.define_methods_on(mod, *methods)
      else
        base.prepend Module.new(*methods)
      end
    end
  end
end
