require "openssl"
require "colorize"

require "./block"
require "./utils"

class BlockChain
  extend Hashes 
  getter :blocks

  def initialize(@blocks : Array(Block))
  end

  def initialize
    @blocks = [] of Block 
    @blocks << Block.genesis
  end

  delegate first,to: @blocks
  delegate last, to: @blocks
  delegate size, to: @blocks

  def next_block(content)
    index = last.index + 1
    timestamp = Time.now.epoch
    previous_hash = last.hash

    pow = ProofOfWork.new(
      timestamp: timestamp,
      previous_hash: previous_hash,
      content: content
    )

    nonce, hash = pow.do_proof_of_work

    block = Block.new(
      hash: hash,
      index: index,
      content: content,
      timestamp: timestamp,
      nonce: nonce,
      previous_hash: previous_hash
    )
  end

  def add_block(block)
    @blocks << block if BlockChain.check_block(block, last)
  end

  def_clone

  def self.hash_of(block)
    str = {
      timestamp:      block.timestamp,
      content:        block.content,
      previous_hash:  block.previous_hash,
      nonce:          block.nonce
    }
    sha256(str.to_json)
  end

  def self.check_block(block, prev_block)
    if block.index != prev_block.index + 1
      puts "invalid index".colorize(:red) 
      false
    elsif block.previous_hash != prev_block.hash
      puts "invalid hash: previous hash".colorize(:red)
      false
    elsif block.hash != hash_of(block)
      puts "invalid hash: hash".colorize(:red)
      puts hash_of(block).colorize(:red)
      puts block.hash.colorize(:red)
      false
    else
      true
    end
  end

  def self.is_valid?(chain)
    if chain.first != Block.genesis
      puts "genesis block is different".colorize(:red)
      return false
    end
    chain.blocks.each_cons(2) do | blocks |
      prev_block, block = blocks
      if !BlockChain.check_block(block, prev_block)
        return false
      end
    end
    true
  end
end
