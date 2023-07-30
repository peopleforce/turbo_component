require_relative "version"

module TurboComponent
  def self.config
    Rails.application.config.turbo_component
  end

  class Engine < ::Rails::Engine

  end
end