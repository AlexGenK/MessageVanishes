# ------------------------------------- уникальная ссылка -----------------------------
class UrlSafeLink
  attr_reader :link

  # передается размер ссылки
  def initialize size
    begin
      @link=SecureRandom.urlsafe_base64(size, false)
    end while Message.find_by(link: @link)
  end

end
