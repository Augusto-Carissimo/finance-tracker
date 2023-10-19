class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def can_track_stock?(ticker)
    under_stock_limit? && !stock_already_track?(ticker)
  end

  def under_stock_limit?
    stocks.count < 10
  end

  def stock_already_track?(ticker)
    stock = Stock.check_db(ticker)
    return false unless stock
    stocks.where(id: stock.id).exists?
  end

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    "Anonymous"
  end

  def self.matches(field, param)
    where("#{field} like ?", "%#{param}%")
  end

  def self.search(param)
    param.strip!
    to_send_back = (email(param) + first(param) + last(param)).uniq
    return nil unless to_send_back
    to_send_back
  end

  def self.email(param)
    matches('email',param)
  end

  def self.first(param)
    matches('first_name',param)
  end

  def self.last(param)
    matches('last_name',param)
  end

  def except_current_user(users)
    users.reject { |user| user.id == self.id }
  end

  def is_friends_with?(id_of_friend)
    !self.friends.where(id: id_of_friend).exists?
  end
end
