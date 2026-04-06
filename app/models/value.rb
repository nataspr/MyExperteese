class Value < ApplicationRecord
  belongs_to :user
  belongs_to :image
  validates :value, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

    # Возвращает [true, оценка] или [false, nil]
    # оценивал ли текущий пользователь данное изображение, и возвращает оценку
  def self.user_valued_exists(user_id, image_id)
    record = find_by(user_id: user_id, image_id: image_id)
    if record
      [true, record.value]
    else
      [false, nil]
    end
  end
end