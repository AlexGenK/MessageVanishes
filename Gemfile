source "https://rubygems.org"

gem "sinatra"
gem "activerecord"
gem "sinatra-activerecord"

group :development, :test do
  gem "sqlite3"
end

group :production do
  gem "pg"
end

group :test do
  gem "rspec"
  gem "rack-test"
  gem "shoulda-matchers"
  gem "timecop"
end