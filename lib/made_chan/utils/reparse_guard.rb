require 'made_chan/utils/filehash.rb'

module MadeChan
  class ReparseGuard < FileHash
    def initialize(name)
      super(name)
    end

    def not_parsed?(id)
      status = read
      return status['id'] < id
    end
  end
end
