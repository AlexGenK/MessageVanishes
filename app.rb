require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:vanishes.db"

class Message < ActiveRecord::Base
end

get '/' do
  erb :message
end