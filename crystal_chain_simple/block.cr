require "openssl" 
require "time"
require "json"

require "./proof_of_work"

class Block
  getter :hash, :index, :content, :timestamp, :nonce, :previous_hash

  def initialize(
    @hash : String,
    @index : Int32,
    @content : String,
    @timestamp : Int64,
    @nonce : Int32,
    @previous_hash : String
  )
  end

  def_clone 

  def_equals

  def self.create_genesis_block
    timestamp = Time.new(2009,1,3).epoch
    previous_hash = "0"
    content = "Hello I'm fine."

    pow = ProofOfWork.new(
      timestamp: timestamp,
      content: content,
      previous_hash: previous_hash
    )
    nonce, hash = pow.do_proof_of_work

    Block.new(
      hash: hash,
      index: 0,
      content: content,
      timestamp: timestamp,
      nonce: nonce,
      previous_hash: previous_hash
    )
  end
end
