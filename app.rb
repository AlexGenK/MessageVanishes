require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

get '/' do
  erb :message
end