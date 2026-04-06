class Image < ApplicationRecord
  belongs_to :theme
  has_many :values, dependent: :destroy
  validates :name, :file, presence: true

  # Скоуп для получения всех изображений определённой темы (только нужные поля)
  scope :theme_images, ->(theme_id) { select(:id, :name, :file, :ave_value).where(theme_id: theme_id) }
end