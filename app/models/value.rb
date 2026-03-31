class Value < ApplicationRecord
  belongs_to :user
  belongs_to :image
  validates :value, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end