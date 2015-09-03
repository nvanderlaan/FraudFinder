require 'bcrypt'

class User < ActiveRecord::Base
  has_many :searches

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validate :password_requirements

  def password
    return nil unless hashed_password
    @password ||= BCrypt::Password.new(hashed_password)
  end

  def password=(new_password)
    @raw_password = new_password
    @password = BCrypt::Password.create(new_password)
    self.hashed_password = @password
  end

  def authenticate(raw_password)
    self.password == raw_password
  end

  private

  def password_requirements
    if new_record? || @raw_password
      unless @raw_password && @raw_password.length > 6
        errors.add(:password, "Your password must be longer!")
      end
    end
  end

end
