
module MadeChan
  class Consts
    @@value = {
      greet: {
        wakeup: 'おはようございます、NAME様。'
      }
    }

    def self.value
      @@value
    end
  end
end
