# app/services/jwt_service.rb
class JwtService
  SECRET = ENV["JWT_SECRET"]

  def self.encode(payload, exp = 7.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue
    nil
  end
end