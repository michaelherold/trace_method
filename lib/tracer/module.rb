module Tracer
  module Module
    def self.new(*methods)
      ::Module.new do
        define_singleton_method(:inspect) { "Tracer(#{methods.join(', ')})" }

        methods.each do |method_name|
          define_method method_name do |*args, &blk|
            trace = caller.first
            line, *_context = trace.split(/:in `/)

            Tracer.config.adapter.store_caller self.class.name, method_name, line

            super(*args, &blk)
          end
        end
      end
    end
  end
end
