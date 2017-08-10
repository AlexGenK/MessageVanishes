# ------------------------------------анализ условий удаления сообщения-------------------------------------
class Analizer

  def self.visit_limit_reached?(method, count)
    ((method=="visits") && (count==0))
  end

  def self.time_expired?(method, created_at, count)
    ((method=="hours") && (Time.now.utc > created_at+3600*count))
  end

end
