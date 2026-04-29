class User < ApplicationRecord
  has_many :values, dependent: :destroy
  # добавление ассоциаций
  before_save { self.email = email.downcase }
  before_create :create_remember_token # генерирует remember_token только при создании записи

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }

  has_secure_password
  validates :password, length: { minimum: 6 }

  class << self
    def new_remember_token
      SecureRandom.urlsafe_base64 # генерирует сырой уникальный токен - в куках хранение
    end

    def encrypt(token)
      Digest::SHA1.hexdigest(token.to_s) # возвращает хэш этого токена (SHA1)
    end
  end

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token) #сохраняет в БД хэш
  end
end
