# frozen_string_literal: true

module TraceMethod
  module ModuleExtensions
    def __trace_method__?; end
  end
end

Module.include TraceMethod::ModuleExtensions
