require "openssl"
require "colorize"

require "./block"
require "./utils"

class BlockChain
  include Hashes 
  getter :blocks

  def initialize(@blocks : Array(Block))
  end

  def initialize
    @blocks = [] of Block 
    @blocks << BlockChain.get_genesis_block
  end

  def last_block
    @blocks.last
  end

  def next_block(content)
    index = last_block.index + 1
    timestamp = Time.now.epoch
    previous_hash = last_block.hash

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

  def is_valid_new_block?(new_block, previous_block)
    if previous_block.index + 1 != new_block.index
      puts "invalid index".colorize(:red)
      return false
    elsif previous_block.hash != new_block.previous_hash
      puts "invalid hash: previous hash".colorize(:red)
      return false
    elsif hash_of(new_block) != new_block.hash
      puts "invalid hash: hash".colorize(:red)
      puts hash_of(new_block)
      puts new_block.hash
      return false
    end
    true
  end

  def add_block(new_block)
    @blocks << new_block if is_valid_new_block?(new_block, last_block)
  end

  def size
    @blocks.size
  end

  def_clone

  private def hash_of(block)
    str = {
      timestamp: block.timestamp,
      content: block.content,
      previous_hash: block.previous_hash,
      nonce: block.nonce
    }.inspect
    sha256(str)
  end

  def self.is_valid_chain?(block_chain_to_validate)
    if block_chain_to_validate.blocks[0] != BlockChain.get_genesis_block
      puts "genesis block is different".colorize(:red)
      return false
    end
    block_chain_to_validate.blocks.each_cons(2) do | blocks |
      prev_block, block = blocks
      if !block_chain_to_validate.is_valid_new_block?(block, prev_block)
        return false
      end
    end
    true
  end

  def self.get_genesis_block
    Block.create_genesis_block
  end
end
