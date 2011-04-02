require 'rubygems'
require 'summer'

class Bot < Summer::Connection
  def did_start_up
    message_channel("Convore Bot Engaged!")
  end

  def message_channel(payload)
    response "PRIVMSG #{@config[:channel]} :#{payload}"
  end

  def message_by_nick(nick,message)
    message_channel("#{nick}: #{message}") 
  end

  def channel_message(sender, channel, message)
    message_by_nick(sender[:nick],message)  
  end
end

Bot.new("irc.freenode.net")
