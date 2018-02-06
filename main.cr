require "colorize"
require "option_parser"
require "./crystal_chain_simple/chain"
require "./crystal_chain_simple/miner"

class Main
  @n : String?
  @e : String?

  ## blockchain simulator
  @@receive_block_chain = Chain.new

  def create_miner(name, channel)
    spawn do
      miner = Miner.new name: name
      epoch = (@e || 10).to_i
      epoch.times do
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
    args = parse_options
  end

  private def parse_options
    OptionParser.parse! do |parser|
      parser.on("-m NUM", "--miner=NUM", "number of miner") { |n|  @n = n }
      parser.on("-e NUM", "--epoch", "") { |e| @e = e }
    end
  end

  def run
    puts "start"
    ch = Channel(String).new
    n = (@n || 3).to_i
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
