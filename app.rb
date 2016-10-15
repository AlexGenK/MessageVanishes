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

  private

  # установка значений по умолчаию
  def set_default_values
    self.count||=1
    self.method||="hours"
    self.link||=generate_link(11)
  end

  # генерация уникальной ссылки 
  def generate_link(size)
    begin
      l=SecureRandom.urlsafe_base64(size, false)
    end while Message.where(link: l).first
    return l
  end

end

# уничтожения сообщения с выводом информации
def destroy_with_info(m)
  m.destroy
  @info="Message destroyed."
  erb :info
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
    if @m.method=="visits"
      if @m.count == 0
        destroy_with_info(@m)
      else
        @m.count-=1
        @m.save
        erb :show
      end
    else
        if Time.now.utc > @m.created_at+3600*@m.count
          destroy_with_info(@m)
        else
          erb :show
        end
    end
  end
end