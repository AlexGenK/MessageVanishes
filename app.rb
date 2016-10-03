require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require "securerandom"

set :database, "sqlite3:vanishes.db"

class Message < ActiveRecord::Base
end

def generate_link(size)
  SecureRandom.urlsafe_base64(size, false)
end

get '/' do
  @m=Message.new
  erb :message
end

post '/' do
  @m=Message.new(params[:message])
  @m.link=generate_link(11)
  @m.save
  erb :add
end