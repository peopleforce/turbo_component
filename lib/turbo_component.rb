# frozen_string_literal: true

require "action_view"
require "active_support/dependencies/autoload"

require_relative "turbo_component/engine"
require_relative "turbo_component/component"

module ActionWire
  class Error < StandardError; end
end
