module Tracer
  class Config
    attr_accessor :adapter
    attr_accessor :app_root
    attr_accessor :ignored

    def app_root?
      !!app_root
    end
  end
end
