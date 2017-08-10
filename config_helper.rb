configure :development do
  require 'sinatra/reloader'
  set :database, "sqlite3:vanishes.db"
  set :server, 'webrick'
end

configure :test do
  set :database, "sqlite3:vanishes_test.db"
end

configure :production do
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'postgres://localhost/vanishes')
end
