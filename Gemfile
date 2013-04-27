source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0.beta1'

# Select the gem you want to use for your database
# Copy and rename the appropriate db/database.yml.example file
# to configure your app to connect to the right database.
#gem 'sqlite3' # SQLITE
#gem 'mysql2'  # MYSQL
gem 'pg'      # POSTGRESQL

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 4.0.0.beta1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'haml-rails'
gem 'feedzirra', :github => 't27duck/feedzirra', :branch => 'lite'
gem 'bcrypt-ruby'
gem 'sanitize'


# The following gems are optional, depending on your configuration.
# Comment them out if you do now want to use them.

# Use unicorn as the app server
gem 'unicorn'

# Deploy with Capistrano
# Default deploy file (with bundle support) can be found in config/deloy.rb
gem 'capistrano', group: :development

# Use whenever to set the crontab on production to
# auto fetch new feed entries (Does not work on Windows)
# Schedule file can be found at config/schedule.rb
gem 'whenever'


# To help prevent possible merge conflicts with upstream, put any
# other gems you'd like in this app below.

