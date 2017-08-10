# ----------------------------------------модель - сообщение-----------------------------------
class Message < ActiveRecord::Base
  validates_presence_of :body, :link, :method, :count
  validates_numericality_of :count, less_than: 10000, message: "in field \"Destroy after\" is too big (max. 9999)" 
  validates_numericality_of :count, greater_than_or_equal_to: 0, message: "in field \"Destroy after\" is too small (min. 0)"

  after_initialize :set_default_values

  # установка значений по умолчаию
  def set_default_values(link_generator: UrlSafeLink.new(11).link)
    self.count||=1
    self.method||="hours"
    self.link||=link_generator
  end

  # метод, уменьшающий счетчик посещений
  def decrement_count!
    self.count-=1 if self.method=="visits"
    save
  end

end
