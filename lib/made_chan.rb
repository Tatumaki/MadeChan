require "made_chan/version"
require 'made_chan/routine'
require 'made_chan/language'
require 'configatron'


module MadeChan
  def call
    return Core.new
  end

  class Core < Language
    def initialize
      super
    end

    #.greet :wakeup, configatron.mastername

    def test(command,params=nil)
      case command.to_sym
      when :say
        say(params,:interface=> :twitter)
      when :twitter
        lookup
      when :twitter_mentions
        loop_up_mentions
      when :twitter_stream
        twitter_stream
      when :tweet
        tweet("てすとなのん",interface: :twitter, mention: MASTER)
      when :routine
        say("るーてぃんてすとなのん\n#{Time.new.to_s}", interface: :twitter,  mention: MASTER)
        params.call(params,self)
      end
    end
  end

  module_function :call
end
