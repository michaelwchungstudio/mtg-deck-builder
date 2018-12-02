class ApplicationController < ActionController::Base
  MTG.configure do |config|
    config.api_version = 1
  end
end
