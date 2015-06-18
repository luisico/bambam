if Rails.env.production? or Rails.env.staging?
  Rails.application.configure do
    config.lograge.enabled = true
    config.lograge.keep_original_rails_log = false
    config.lograge.ignore_actions = %w( health_check/health_check#index )
  end
end
