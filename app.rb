require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require "securerandom"

set :server, 'webrick'
set :database, "sqlite3:vanishes.db"

class Message < ActiveRecord::Base
  after_initialize :set_default_values
  def set_default_values
    self.count||=1
    self.method||="hours"
  end
end

def destroy_with_info(m)
  m.destroy
  @info="Message destroy."
  erb :info
end

def generate_link(size)
  SecureRandom.urlsafe_base64(size, false)
end

get '/' do
  @m=Message.new
  erb :new
end

post '/' do
  @m=Message.new(params[:message])
  @m.link=generate_link(11)
  @m.save
  erb :create
end

get '/message/:link' do
  @m=Message.where(link: params[:link]).first
  unless @m
    @info="Message not found."
    erb :info
  else 
    if @m.method=="visits"
      if @m.count == 0
        destroy_with_info(@m)
      else
        @m.count-=1
        @m.save
        erb :show
      end
    else
        if Time.now.utc > @m.created_at+360*@m.count
          destroy_with_info(@m)
        else
          erb :show
        end
    end
  end
end