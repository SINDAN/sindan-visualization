source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails', '6.1.4.3'

gem 'mysql2'

gem 'puma', '~> 5.5'

gem 'devise'

gem 'slim-rails'
gem 'sassc-rails'
gem 'webpacker', '~> 5.0'
gem 'jbuilder', '~> 2.7'

gem 'kaminari'
gem 'ransack'
gem 'breadcrumbs_on_rails'

gem 'slack-notifier'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
#gem 'bcrypt', '~> 3.1.7'
gem 'bcrypt', '3.1.12'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem 'bootsnap', '>= 1.4.4', require: false

# Use Capistrano for deployment
group :development do
  gem 'capistrano-ext'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-nodenv'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development, :test do
#  gem 'web-console'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  gem 'spring'
  gem 'awesome_print'
  gem 'rails-erd'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'capybara'
  gem 'webrat'
  gem 'factory_bot_rails'
#  gem 'selenium-webdriver'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# net-smtp, net-imap and net-pop were removed from default gems in Ruby 3.1, but is used by the `mail` gem.
# So we need to add them as dependencies until `mail` is fixed: https://github.com/mikel/mail/pull/1439
gem "net-smtp", require: false
gem "net-imap", require: false
gem "net-pop", require: false
