require 'spec_helper'

describe MadeChan do
  it 'has a version number' do
    expect(MadeChan::VERSION).not_to be nil
  end

  madechan = MadeChan.call
  it "Greet should be おはようございます、#{MadeChan::MASTER}様。"  do
    madechan.greet(:wakeup,MadeChan::MASTER) == ('おはようございます、'+MadeChan::MASTER+'様。')
  end
end

