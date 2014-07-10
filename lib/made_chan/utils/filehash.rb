module MadeChan
  class FileHash
    def initialize(name, dir: './config/')
      @status = {
        'id' => 0
      }
      @path = "#{dir}#{name}.guard"
      create
      io(merge: @status)
    end
    
    def read
      return io
    end

    def write(id)
      return io(merge: id) if id.is_a?(Hash)
      return io(merge: {"id"=>id})
    end

    private
    def create
      FileUtils.touch(@path) unless File.exist?(@path)
    end

    def io(overwrite: nil, merge: nil)
      open(@path, "a+") do |file|
        hash = eval(file.read) || {}
        @status.merge(hash)
        file.truncate(0)
        @status = overwrite     if overwrite
        @status.merge!(merge)   if merge
        file.puts @status.to_s
      end
      return @status
    end
  end
end
