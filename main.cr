require "colorize"
require "./crystal_chain_simple/block_chain"
require "./crystal_chain_simple/miner"

class Hoge

  ## blockchain simulator
  @@receive_block_chain = BlockChain.new

  def create_miner(name, channel)
    spawn do
      miner = Miner.new name: name
      10.times do
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
    @@receive_block_chain = miner.block_chain
  end

  def initialize

  end

  def run
    puts "start"
    ch = Channel(String).new
    th1 = create_miner name: "miner1", channel: ch
    th2 = create_miner name: "miner2", channel: ch
    th3 = create_miner name: "miner3", channel: ch
    3.times do 
      puts ch.receive + " end"
    end

    puts "block chain result"

    @@receive_block_chain.blocks.each do |block|
      puts "*** Block #{block.height} ***"
      puts "hash: #{block.hash}"
      puts "previous_hash: #{block.previous_hash}"
      puts "timestamp: #{block.timestamp}"
      # TODO: merkle root
      # puts "transactions_hash: #{block.transactions_hash}"
      puts "transactions: #{block.transactions}"
      puts "nonce: #{block.nonce}"
      puts ""
    end
  end

end

Hoge.new.run
