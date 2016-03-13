class Script
  attr_reader :command, :args

  def initialize(firewood)
    tokens = firewood.contents.split(' ').reject do |el|
      el.start_with?('#') # remove tags
    end
    @command = tokens.shift
    @args = tokens
  end

  def arg
    args.join(' ')
  end
end
