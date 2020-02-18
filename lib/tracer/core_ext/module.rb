# frozen_string_literal: true

module Tracer
  module ModuleExtensions
    def __tracer__?; end
  end
end

Module.include Tracer::ModuleExtensions
