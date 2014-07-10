

module MadeChan
  class Task
    @@names = []

    def initialize(name, multiple: false)
      raise 'Already exists.' if @@names.include?(name)
      @body = {}
      @name = name
      @multiple =  multiple
      unless multiple
        @@names << name
      end
    end

    def create(array)
      array.each do |a|
        if a.is_a?(Fixnum) or a.is_a?(Float)
          @body.store(a.to_s.to_sym,proc{})
        else
          @body.store(a,proc{})
        end
      end
    end
    
    def <<(key,func)
      raise unless func.is_a?(Proc)
      raise if @@names.include?(key) and not multiple
      @body.store(key,func)
    end
  
    def [](key)
      @body[key]
    end

    def set(key, &block)
      @body[key] = block
    end

    def to_a
      @body
    end
    
    def free
      unless multiple
        @@names.delete(@name)
      end
      @body = nil
      @name = nil
    end
  end
end
