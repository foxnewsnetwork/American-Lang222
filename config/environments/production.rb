EmailGen::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  
    # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  require 'tlsmail'
  Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)

  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.smtp_settings = {
    :enable_starttls_auto => true,
    :address            => 'smtp.gmail.com',
    :port               => 587,
    :tls                  => true,
    :domain             => 'gmail.com', #you can also use google.com
    :authentication     => :plain,
    :user_name          => 'ingidio.tv@gmail.com',
    :password           => 'wtfisthisbullshit11'
  }
  # If you're reading this on github and lol-ing about how you found our password to our email just sitting there nicely labeled, we ask that you please don't ID-theft us. I mean, seriously, we're just a small start-up with 3 dudes who are stil struggling to finish school. We sustain ourselves largely on ramen and tap water while battling with technology we barely understand all in hopes that we can do something great for all the gamers out there. If you're a true hax0r, why not join us or at least hack someone else bigger (like Sony)
end
