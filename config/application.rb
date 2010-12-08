require File.expand_path('../boot', __FILE__)
require 'rails/all'
Bundler.require(:default, Rails.env) if defined?(Bundler)
module Handtracker
  class Application < Rails::Application
    #config.active_record.observers = (move from environment.rb)
    config.autoload_paths += %W(#{config.root}/lib)
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
  end
end