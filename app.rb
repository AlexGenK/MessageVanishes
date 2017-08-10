require 'sinatra'
require 'active_record'
require 'sinatra/activerecord'

require './config_helper'

require './message'
require './post_message'
require './url_safe_link'
require './analizer'

# создание сообщения
get '/' do
  @m=Message.new
  erb :new
end

# запись сообщения в БД
post '/' do
  saved_message=PostMessage.new(params)
  @m=saved_message.message
  @error=saved_message.error
  @error ? erb(:new) : erb(:create)
end

# вывод сообщения и, если требуется, его удаление
get '/message/:link' do
  @m=Message.where(link: params[:link]).first
  unless @m
    @info="Message not found."
    erb :info
  else
    if Analizer.visit_limit_reached?(@m.method, @m.count) || Analizer.time_expired?(@m.method, @m.created_at, @m.count)
      @m.destroy  
      @info="Message destroyed."
      erb :info
    else
      @m.decrement_count!
      erb :show
    end
  end
end
