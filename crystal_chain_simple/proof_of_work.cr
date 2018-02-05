require "openssl"
require "json"

class ProofOfWork
  getter :timestamp, :content, :previous_hash

  def initialize(
    @timestamp : Int64,
    @content : String,
    @previous_hash : String)
  end

  def calc_hash_with_nonce(nonce)
    hash = OpenSSL::Digest.new("SHA256")
    s = {
      timestamp: @timestamp,
      content: @content,
      previous_hash: @previous_hash,
      nonce: nonce
    }.inspect
    hash.update(s)
    hash.hexdigest
  end

  # TODO: difficulty
  def do_proof_of_work(difficulty = "0000")
    nonce = 0

    loop do
      hash = calc_hash_with_nonce nonce
      if hash.starts_with? difficulty
        return {nonce, hash}
      else
        nonce += 1
      end
    end
  end
end
