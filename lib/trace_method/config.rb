# frozen_string_literal: true

module TraceMethod
  class Config
    attr_accessor :adapter
    attr_accessor :app_root
    attr_accessor :ignored

    # :reek:NilCheck
    def app_root?
      !app_root.nil?
    end
  end
end
