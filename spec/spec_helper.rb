require "active_support/all"
require "./app.rb"

Bundler.require(:default)

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.formatter = :documentation
end
