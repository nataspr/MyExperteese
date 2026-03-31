class User < ApplicationRecord
  has_many :values, dependent: :destroy
  # добавление ассоциаций
end
