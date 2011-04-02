require 'rubygems'
require 'summer'
require 'eventmachine'

$conn
$irc_bot
$messages = []

module EchoServer
  def post_init
    puts "-- someone connected to the echo server!"
  end

  def receive_data data
    send_data ">>>you sent: #{data}"
    $irc_bot.message_by_nick("telnet", data)
    close_connection if data =~ /quit/i
  end

  def unbind
    puts "-- someone disconnected from the echo server!"
  end
end

class IRCBot < Summer::Connection
  def did_start_up
    message_channel("Convore Bot Engaged!")
  end

  def message_channel payload
    response "PRIVMSG #{@config[:channel]} :#{payload}"
  end

  def message_by_nick nick,message
    message_channel("#{nick}: #{message}") 
  end

  def channel_message(sender, channel, message)
    $messages.unshift({:sender => sender, :message =>message})
  end
end

$irc_bot = IRCBot.new("irc.freenode.net", 6667, true)

$irc_bot.send("startup!")

Thread.new do 
  loop do
    $irc_bot.send("parse", $irc_bot.connection.gets)
    $messages.each do |message|
      $conn.send_data ">>>#{message[:sender][:nick]} sent #{message[:message]}\n" if $conn
    end
    $messages.clear
  end
end

EventMachine::run {
  EventMachine::start_server "127.0.0.1", 8081, EchoServer do |conn|
    $conn = conn
  end
}
