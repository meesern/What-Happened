require 'rubber'
require 'xmpp4r'
require 'xmpp4r/pubsub'
require 'xmpp4r/pubsub/helper/servicehelper.rb'
require 'xmpp4r/pubsub/helper/nodebrowser.rb'
require 'xmpp4r/pubsub/helper/nodehelper.rb'

include Jabber

Jabber::debug = true

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
    create_root_node
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

  def xmpp_create_node(path)
    create_replay_node(path)
    path
  end

  def xmpp_replay_start(replayid)
    logger.info("starting replay")
    find_replay(replayid)
    pubstep(@replay.from,@replay.to)
    true
  end

  def xmpp_replay_stop(replayid)
    logger.info("stopping replay")
    find_replay(replayid)
    @replay.running = false
    @replay.save!
  end

  def find_replay(replayid)
    @replay = Replay.find(replayid)
  end

  def pubstep(from,to)
    start,fin = spanify(from,to)
    report, report2 = @replay.aspect.reports.known_inside(start,fin).limited(2)
    if !report.nil? && @replay.running
      logger.info("publishing #{report.xml}")
      publish(@replay.node,report.xml)
      later = report2.andand.known || report.known
      delay = later - report.known
      rate = @replay.rate || 1
      rate = 1 if rate.zero?
      delay = delay * rate 
      delay = @replay.gapskip if (@replay.gapskip > 0 && delay > @replay.gapskip)
      delay = 1 if delay < 1
      logger.info("scheduling for #{delay}secs")
      add_timer(0.1) { 
        @replay.reload
        pubstep(later,to) 
      }
    else
      xmpp_replay_stop(@replay.id)
    end
  end

  #
  # Pub-sub replay publishing
  #

  def pubsub
    @lpubsub ||= PubSub::ServiceHelper.new($im, "pubsub.#{$server}")
  end

  def create_root_node
    begin
      create_replay_node("/home/#{$server}/#{$username}")
      create_replay_node("/home/#{$server}/#{$username}/replay")
    rescue
    end
  end

  def create_replay_node(path)
    logger.info("Creating node #{path}")
    pubsub.create_node(path)
    path
  end

  #message should be the xml measurement
  def publish(node, message)
    item = Jabber::PubSub::Item.new
    item.add(REXML::Document.new(message))
    pubsub.publish_item_to(node,item)
  end

end

