require "openssl"
require "colorize"

require "./chain"

class Miner
  getter :name, :chain
  def initialize(@name : String)
    @chain = Chain.new
  end

  def accept(chain)
    puts "#{@name} checks received block chain. Size: #{@chain.size}"
    if chain.size > @chain.size
      if Chain.is_valid? chain
        puts "#{@name} accepted received blockchain".colorize(:blue)
        @chain = chain.clone
      else
        puts "Received blockchain invalid"
      end
    end
  end

  def add_new_block(content)
    next_block = @chain.next_block(content)
    @chain.add(next_block)
    puts "#{@name} add new block: #{next_block.hash}".colorize(:green)
  end
end
