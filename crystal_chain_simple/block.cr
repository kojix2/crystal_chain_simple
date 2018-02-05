require "openssl" 
require "time"

require "./proof_of_work"

class Block
  getter :hash, :height, :transactions, :timestamp, :nonce, :previous_hash

  def initialize(
    @hash : String,
    @height : Int32,
    @transactions : String,
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
    transactions = "Hello I'm fine."

    pow = ProofOfWork.new(
      timestamp: timestamp,
      transactions: transactions,
      previous_hash: previous_hash
    )
    nonce, hash = pow.do_proof_of_work

    Block.new(
      hash: hash,
      height: 0,
      transactions: transactions,
      timestamp: timestamp,
      nonce: nonce,
      previous_hash: previous_hash
    )
  end
end
