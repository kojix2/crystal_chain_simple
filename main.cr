require "colorize"
require "option_parser"
require "./crystal_chain_simple/chain"
require "./crystal_chain_simple/miner"

class Main

  ## blockchain simulator
  @@receive_block_chain = Chain.new

  def create_miner(name, channel)
    spawn do
      miner = Miner.new name: name
      @opts[:n].times do
        sleep [1, 2, 3].sample 
        miner.accept @@receive_block_chain
        miner.add_new_block("I am #{name}")
        broadcast miner
      end
      channel.send(name)
    end
  end

  def broadcast(miner)
    puts "#{miner.name} broadcasted"
    @@receive_block_chain = miner.chain
  end

  def initialize
    @opts = {
      :miner => 5,
      :n => 3
    }
    args = parse_options
  end

  private def parse_options
    OptionParser.parse! do |parser|
      parser.on("-m NUM", "--miner=NUM", "number of miner") { |n|  @opts[:miner] = n.to_i }
      parser.on("-n NUM", "--num=NUM", "loop of each miner") { |e| @opts[:n] = e.to_i }
      parser.on("-h", "--help", "Show this help") { puts parser; exit }
    end
  end

  def run
    puts "start"
    ch = Channel(String).new
    n = @opts[:miner]
    n.times do |i|
      create_miner name: "mineri#{i+1}", channel: ch
    end
    n.times do 
      puts ch.receive + " end"
    end

    puts "block chain result"

    @@receive_block_chain.blocks.each do |block|
      puts "*** Block #{block.index} ***".colorize.fore(:black).back(:white)
      puts "hash: #{block.hash}"
      puts "timestamp: #{block.timestamp}"
      puts "contents: #{block.content}"
      puts "nonce: #{block.nonce}"
      puts ""
    end
  end

end

Main.new.run
