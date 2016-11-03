require 'sinatra'
require 'active_record'
require 'sinatra/activerecord'

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

# ----------------------------------------модель - сообщение-----------------------------------
class Message < ActiveRecord::Base
  validates_presence_of :body, :link, :method, :count
  validates_numericality_of :count, less_than: 10000, message: "in field \"Destroy after\" is too big (max. 9999)" 
  validates_numericality_of :count, greater_than_or_equal_to: 0, message: "in field \"Destroy after\" is too small (min. 0)"

  after_initialize :set_default_values

  # установка значений по умолчаию
  def set_default_values(link_generator: UrlSafeLink.new(11, Message.pluck(:link)).link)
    self.count||=1
    self.method||="hours"
    self.link||=link_generator
  end

  # метод удаляющий записи по условию
  def destroyer?
    if ((self.method=="visits") && (self.count==0))||((self.method=="hours") && (Time.now.utc > self.created_at+3600*self.count))
      destroy
      return true
    end
    return false
  end

  # метод, уменьшающий счетчик посещений
  def decrement_count!
    self.count-=1 if self.method=="visits"
    save
  end

end

# класс - уникальная ссылка
class UrlSafeLink
  attr_reader :link

  # передается размер ссылки и список уже существующих ссылок
  def initialize size, links_list
    begin
      @link=SecureRandom.urlsafe_base64(size, false)
    end while links_list.include? @link
  end

end

# ---------------------------------маршруты---------------------------------------------------
# создание сообщения
get '/' do
  @m=Message.new
  erb :new
end

# запись сообщения в БД
post '/' do
  @m=Message.new(params[:message])
  if params[:error_field] && params[:error_field].length > 0
    @error=params[:error_field]
    return erb :new
  end
  if @m.save
    erb :create
  else
    @error=@m.errors.full_messages.first
    erb :new
  end
end

# вывод сообщения и, если требуется, его удаление
get '/message/:link' do
  @m=Message.where(link: params[:link]).first
  unless @m
    @info="Message not found."
    erb :info
  else
    if @m.destroyer?  
      @info="Message destroyed."
      erb :info
    else
      @m.decrement_count!
      erb :show
    end
  end
end