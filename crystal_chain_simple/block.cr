require "openssl" 
require "time"

require "./proof_of_work"

class Block
  getter :hash, :height, :transactions, :timestamp, :nonce, :previous_hash

  def initialize(hash : String, height : Int32, transactions : String, timestamp : Int64, nonce : Int32, previous_hash : String)
    @hash = hash
    @height = height
    # TODO: merkle root
    @transactions = transactions
    @timestamp = timestamp
    @nonce = nonce
    @previous_hash = previous_hash
  end

  def ==(other : Block)
    self.hash == other.hash &&
      self.height == other.height &&
      self.transactions == other.transactions &&
      self.timestamp == other.timestamp &&
      self.nonce == other.nonce &&
      self.previous_hash == other.previous_hash
  end

  def clone
    Block.new(
      hash: self.hash.clone,
      height: self.height.clone,
      transactions: self.transactions.clone,
      timestamp: self.timestamp.clone,
      nonce: self.nonce.clone,
      previous_hash: self.previous_hash.clone
    )
  end

  # ジェネシス・ブロックを作成する
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
    nonce = nonce.to_i
    hash = hash.to_s
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
