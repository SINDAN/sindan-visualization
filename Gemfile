source "https://rubygems.org"

gem "rails", "7.1.4"

gem "mysql2"

gem "puma", ">= 5.0"

gem "devise"

gem "sprockets-rails"
gem "jsbundling-rails"

gem "slim-rails"
gem "jbuilder"

gem "kaminari"
gem "ransack"
gem "breadcrumbs_on_rails"

gem "slack-notifier"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"
# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"
# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
end

# Use Capistrano for deployment
group :development do
  gem "capistrano-ext"
  gem "capistrano-rails"
  gem "capistrano-rbenv"
  gem "capistrano-nodenv"
  gem "capistrano-bundler"
  gem "capistrano-passenger"
end

group :development, :test do
  # gem "web-console"
  gem "rack-mini-profiler"
  # gem "spring"
  gem "awesome_print"
  gem "rails-erd"
  gem "foreman"
end

group :development, :test do
  gem "rspec-rails"
  gem "rails-controller-testing"
  gem "capybara"
  gem "selenium-webdriver"
  gem "factory_bot_rails"
end
