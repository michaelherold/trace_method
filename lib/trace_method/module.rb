# frozen_string_literal: true

require_relative 'caller_extractor'
require_relative 'name_extractor'

module TraceMethod
  module Module
    def self.new(*methods)
      ::Module.new do
        define_singleton_method(:__trace_method__?) { true }
        define_singleton_method(:inspect) { "TraceMethod(#{instance_methods.sort.join(', ')})" }

        Module.define_methods_on(self, *methods)
      end
    end

    def self.define_methods_on(mod, *methods)
      methods.each do |method_name|
        mod.define_method method_name do |*args, &blk|
          name = NameExtractor.call(self)
          trace = TraceMethod::CallerExtractor.call(caller)
          line, *_context = trace.split(/:in `/)
          line = line.delete_prefix(TraceMethod.config.app_root) if TraceMethod.config.app_root?

          TraceMethod.config.adapter.add_caller name, method_name, line

          super(*args, &blk)
        end
      end
    end
  end
end
