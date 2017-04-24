# frozen_string_literal: true

# Script
class Script
  attr_reader :command, :args

  def initialize(firewood)
    tokens = firewood.contents.split(" ").reject do |el|
      el.start_with?("#") # remove tags
    end
    @command = tokens.shift
    @args = tokens
  end

  def arg
    args.join(" ")
  end

  def first_arg
    @args.first
  end

  def args_size
    @args.size
  end

  def no_args?
    @args.empty?
  end
end
