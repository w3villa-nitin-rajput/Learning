class JwtService
  SECRET = ENV["JWT_SECRET"]

  def self.encode(payload, exp = 7.days.from_now)
    puts "[JWT] Encoding token with payload: #{payload.inspect}"
    puts "[JWT] SECRET configured: #{SECRET.present?}"
    payload[:exp] = exp.to_i
    token = JWT.encode(payload, SECRET)
    puts "[JWT] Token encoded successfully"
    token
  end

  def self.decode(token)
    puts "[JWT] Decoding token... (first 20 chars: #{token.to_s.first(20)})"
    puts "[JWT] SECRET configured: #{SECRET.present?}"
    decoded = JWT.decode(token, SECRET)[0]
    result = HashWithIndifferentAccess.new(decoded)
    puts "[JWT] Token decoded successfully: user_id=#{result[:user_id]}"
    result
  rescue JWT::ExpiredSignature => e
    puts "[JWT] Token expired: #{e.message}"
    nil
  rescue JWT::DecodeError => e
    puts "[JWT] Decode error: #{e.message}"
    nil
  rescue => e
    puts "[JWT] Unexpected error: #{e.class} - #{e.message}"
    nil
  end
end
