require 'spec_helper'

describe MadeChan do
  it 'has a version number' do
    expect(MadeChan::VERSION).not_to be nil
  end

  madechan = MadeChan::Core.new
  it "Greet should be おはようございます。"  do madechan.greet == 'おはようございます。';  end
end

