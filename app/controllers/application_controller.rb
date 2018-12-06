class ApplicationController < ActionController::Base
  MTG.configure do |config|
    config.api_version = 1
  end

  def after_sign_in_path_for(resource)
    user_profile_path(current_user)
  end
end
