source 'https://rubygems.org'

gem 'rails', '3.2.2'
gem 'bootstrap-sass', '~> 2.0.1'
gem 'bcrypt-ruby', '3.0.1'

group :development do
  gem 'sqlite3', '1.3.5'
  gem "haml-rails", "~> 0.3.4"
  unless ENV["CI"]
    # http://about.travis-ci.org/docs/user/languages/ruby/ (search for ruby-debug)
    gem 'ruby-debug19', :require => 'ruby-debug'
  end
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

gem "haml", "~> 3.1.4"
gem 'jquery-rails', '~> 2.0.0'

group :test, :development do
  gem 'rspec-rails', '~> 2.8.rc'
end

group :test do
  gem 'spork', '~> 0.9.0'
  gem 'capybara', '1.1.2'
  gem 'cucumber-rails', '~> 1.3.0'
  gem 'database_cleaner', '~> 0.7.0'
  gem 'factory_girl_rails', '~> 3.0'
  unless ENV["CI"]
    gem 'launchy'
  end
end

group :production do
  gem 'pg', '~> 0.12'
end

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
