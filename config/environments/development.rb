Lovestockholm::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  # config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  
  # tmp dir for cache must be setup outside virtualbox shared folder for sass cached sprites to work
  config.assets.configure do |env|
    env.cache = ActiveSupport::Cache::FileStore.new('/mnt/tmp')
  end

  Rails.configuration.ga_id = 'UA-69088337-1'
  Rails.configuration.vk_id = '5114153'
  Rails.configuration.vk_secret = 'pGztFeGrhZuFUIpPhpcW'
  Rails.configuration.fb_id = '460998214072278'
  Rails.configuration.fb_secret = '2c436a391797ee8eec3272b1f75c0e18'
end
