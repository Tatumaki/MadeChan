require 'made_chan/consts'
require 'tweetstream'
require 'twitter'
require 'pry'
require './config/interface'
require 'mono_talk'
require 'made_chan/utils/reparse_guard'

module MadeChan
  class Language #Interface
    CONSOLE_ICON  = ['-','\\','|','/','*']
    LANGUAGE_INTERFACE = {
      'TEST' => proc{ |params, this| this.greet(:wakeup, MadeChan::MASTER)},
      'SHUTDOWN' => proc{ |params, this| this.shutdown; "終了中なのです"}
    }

    TweetStream.configure do |config|
      config.consumer_key       = TWITTER_TOKENS[:consumer_key]
      config.consumer_secret    = TWITTER_TOKENS[:consumer_secret]
      config.oauth_token        = TWITTER_TOKENS[:oauth_token]
      config.oauth_token_secret = TWITTER_TOKENS[:oauth_token_secret]
      config.auth_method        = :oauth
    end
    TWITTER_STREAM_INTERFACE = TweetStream::Client.new

    TWITTER_INTERFACE = Twitter::REST::Client.new do |config|
      config.consumer_key        = TWITTER_TOKENS[:consumer_key]
      config.consumer_secret     = TWITTER_TOKENS[:consumer_secret]
      config.access_token        = TWITTER_TOKENS[:oauth_token]
      config.access_token_secret = TWITTER_TOKENS[:oauth_token_secret]
    end

    def initialize
      @que = Array.new
      @que_semaphore = Mutex.new
      @brain = nil
      @shutdown = false

      run_tcp_thread
      run_twitter_thread
    end

    def add_que(hash)
      @que_semaphore.synchronize { @que << hash }
    end

    def run_twitter_thread
      if TWITTER_INTERFACE
        puts 'Twitter進出なう！'
        @twitter_guard = ReparseGuard.new(:twitter)
        TWITTER_STREAM_INTERFACE.on_timeline_status do |tweet|
          puts tweet.text
          command = tweet.text.to_s.gsub("@madechan_ ",'')
          puts 'きゅーついかするよ -> ' + command
          add_que({'command'=> command, 'params'=>{'raw'=> tweet, 'mention'=> tweet.screen_name, 'body'=> tweet.text}})
          @twitter_guard.write(tweet.id)
        end

        @twitter_thread = Thread.new do
          Thread.pass
          twitter_stream
        end
      end
    end

    def run_tcp_thread
      @tcp_thread = Thread.new do
        Thread.pass
        @brain = MonoTalk::Server.new(:tcp, INTERFACE.merge(LANGUAGE_INTERFACE), body: self)
        until @shutdown do
          @brain.accept
        end
      end
#      @teller = MonoTalk::Client.new(:tcp)
    end

    def run_routine_thread
      @routine_thread = Thread.new do
        Thread.pass
        

        sleep 1
      end
    end

    def shutdown
      @shutdown = true
      @twitter_thread.kill if @twitter_thread
    end

    def wait
      puts "まってるよ -> #{@tcp_thread}, #{@twitter_thread}"
      i = 0
      until @shutdown do
        @que_semaphore.synchronize {
          print "\rきゅー走査中・・・・・#{CONSOLE_ICON[i]}"
          if @que.size > 0
            puts "処理中・・・ -> #{@que.first}"
            @brain.routing(@que.first)
            @que.delete_at 0
          end
        }
        Thread.pass
        sleep 0.1
        i = (i+1)%5
      end
      @tcp_thread.kill if @tcp_thread
    end
    
    def call(params)

    end

    def greet(as, who)
      Consts.value[:greet][as].gsub('NAME',who)
    end

    def lookup
      return look_up_tweet
    end
    
    def say(something ,interface: STDOUT, mention: nil )
      something = "@#{mention} #{something}" if mention
      case interface
      when :twitter
        puts 'Said in Twitter '+something.to_s
        TWITTER_INTERFACE.update(something)
      else
        interface.puts something
      end
    end

    def tweet(something, mention: nil)
      say(something, interface: :twitter, mention: mention)
    end

    def look_up_tweet
      return TWITTER_INTERFACE.home_timeline
    end

    def loop_up_mentions
      return TWITTER_INTERFACE.mentions_timeline
    end

    def twitter_stream
      puts 'ついったー監視ちゅう'
      TWITTER_STREAM_INTERFACE.userstream
    end
  end
end
