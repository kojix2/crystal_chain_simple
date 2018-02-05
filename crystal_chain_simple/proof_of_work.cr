require "openssl"
require "json"

require "./utils"

class ProofOfWork
  include Hashes 
  getter :timestamp, :content, :previous_hash

  def initialize(
    @timestamp : Int64,
    @content : String,
    @previous_hash : String)
  end

  def calc_hash_with_nonce(nonce)
    s = {
      timestamp:      @timestamp,
      content:        @content,
      previous_hash:  @previous_hash,
      nonce:          nonce
    }.to_json
    sha256(s)
  end

  def do_proof_of_work(difficulty = "0000")
    nonce = 0
    hash = calc_hash_with_nonce(nonce)

    until hash.starts_with? difficulty
      nonce += 1
      hash = calc_hash_with_nonce(nonce)
    end

    return {nonce, hash}
  end
end
