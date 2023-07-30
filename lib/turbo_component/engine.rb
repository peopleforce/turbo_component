require_relative "version"

module TurboComponent
  def self.config
    Rails.application.config.action_wire
  end

  class Engine < ::Rails::Engine

  end
end