# frozen_string_literal: true

unless Object.new.respond_to?(:then)
  module Kernel
    alias then yield_self
  end
end
