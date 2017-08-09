source 'https://rubygems.org'

gem 'rails_12factor', group: :production

gem 'rails', '5.1.3'

gem 'mysql2'

gem 'devise'

gem 'slim-rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.5'

gem 'bootstrap-sass'
gem 'font-awesome-rails'

gem 'kaminari'
gem 'ransack'

gem 'slack-notifier'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'
# gem 'passenger'

# Use Capistrano for deployment
group :development do
  gem 'capistrano-ext'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development, :test do
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'capybara'
  gem 'webrat'
  gem 'factory_girl_rails'
#  gem 'selenium-webdriver'
end

group :development, :test do
#  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'awesome_print'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
