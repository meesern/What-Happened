require 'rubber'
include Jabber

class XmppWorker < BackgrounDRb::MetaWorker
  set_worker_name :xmpp_worker
  def create(opts = nil)
    # this method is called, when worker is loaded for the first time
    opts ||= {}
    opts[:username] ||= RUBBER_CONFIG.app_name
    opts[:server]   ||= RUBBER_CONFIG.domain
    opts[:password] ||= RUBBER_CONFIG.jabber_password
    $username =  opts[:username]
    $server =    opts[:server]
    $password =  opts[:password]

    $im = Client.new(JID::new($username+"@"+$server))
    maintain
    add_periodic_timer(10) { maintain }
  end

  def maintain
    unless connected?
      begin
        $im.connect
        $im.auth($password)
        $im.add_message_callback { |message| self.incomming(message) }
        $im.send(Presence.new(nil,"Available"))
      rescue
        ev = $!
        puts("Jabber connection failed with: #{ev}")
      end
    end
  end

  def connected?
    $im.is_connected?
  end

  def incomming(message)
    begin
      parse_message(message.body) unless message.body.nil?
    rescue 
      #Catch errors as ordinary crash reporting does not work from the
      #xmpp4r callback
      puts $!
      raise
    end
  end

  def parse_message(body)
    #ClerksReport.file( Hpricot(body).to_plain_text )
    # Bogus aspect id
    ClerksReport.file( body, 3 )
  end

end

