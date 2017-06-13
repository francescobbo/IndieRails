source 'https://rubygems.org'
ruby '2.4.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.1'

# Use sqlite3 as the database for Active Record
gem 'pg'

gem 'puma', '~> 3.7'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'slim-rails'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

gem 'redcarpet'
gem 'friendly_id'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'meta-tags'
gem 'rouge'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'byebug'

  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
end

group :development do
  gem 'web-console'
  gem 'listen', '>= 3.0.5', '< 3.2'

  gem 'spring'

  gem 'rubocop', require: false
end

group :test do
  gem 'database_cleaner'
  gem 'timecop'
  gem 'shoulda-matchers', require: false
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
