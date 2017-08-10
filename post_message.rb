# ---------------------------------запись сообщения-----------------------------------------
class PostMessage

  attr_reader :message
  attr_reader :error

  def initialize(params)
    @message=Message.new(params[:message])
    if params[:error_field] && params[:error_field].length > 0
      @error=params[:error_field]
    else
      @error=@message.full_messages.first unless @message.save
    end
  end

end
