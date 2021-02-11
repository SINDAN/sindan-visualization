source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails_12factor', group: :production

gem 'rails', '5.2.4.5'

gem 'mysql2'

gem 'devise'

gem 'slim-rails'
gem 'sassc-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
# gem 'mini_racer', platforms: :ruby

gem 'jquery-rails'
gem 'jbuilder', '~> 2.5'
gem 'bootstrap-sass'
gem 'font-awesome-rails'

gem 'momentjs-rails'
gem 'bootstrap3-datetimepicker-rails'

gem 'kaminari'
gem 'ransack'
gem 'breadcrumbs_on_rails'

gem 'slack-notifier'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '3.1.12'

# Use Capistrano for deployment
group :development do
  gem 'capistrano-ext'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
end

gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development, :test do
#  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
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
