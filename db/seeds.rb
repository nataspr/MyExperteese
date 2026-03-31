# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# ===== Очистка таблиц (с учётом внешних ключей) =====
Value.delete_all
Image.delete_all
Theme.delete_all
User.delete_all

# Сброс последовательностей (чтобы id начинались с 1)
def reset_pk_sequence(table_name)
  ActiveRecord::Base.connection.reset_pk_sequence!(table_name)
end

reset_pk_sequence('values')
reset_pk_sequence('images')
reset_pk_sequence('themes')
reset_pk_sequence('users')


User.create!(
  name: "Ivan",
  email: "ivan@try.com"
)
User.create!(
  name: "User",
  email: "user@example.com"
)

# Создание тем (первая тема – заглушка, опционально)
themes = Theme.create!([
  { name: "-----", qty_items: 0 },                           # id: 1
  { name: "Самая симпатичная аквариумная рыба", qty_items: 5 },   # id: 2
  { name: "Наиболее приятный окрас у шиншиллы", qty_items: 5 },    # id: 3
  { name: "Лучший домашний питомец", qty_items: 5 }                # id: 4
])

# Изображения (theme_id соответствуют созданным выше)
images_fish = [
  { name: "Вишневый барбус", file: "fish1.jpg", theme_id: 2, ave_value: 0 },
  { name: "Петушок", file: "fish2.jpg", theme_id: 2, ave_value: 0 },
  { name: "Хромис красавец", file: "fish3.jpg", theme_id: 2, ave_value: 0 },
  { name: "Пецилия", file: "fish4.jpg", theme_id: 2, ave_value: 0 },
  { name: "Неон красный", file: "fish5.jpg", theme_id: 2, ave_value: 0 }
]

images_chinchilla = [
  { name: "Чёрный бархат", file: "chinchilla1.jpg", theme_id: 3, ave_value: 0 },
  { name: "Бело-розовый", file: "chinchilla2.jpg", theme_id: 3, ave_value: 0 },
  { name: "Гетеробежевый", file: "chinchilla3.jpg", theme_id: 3, ave_value: 0 },
  { name: "Белый Вильсона", file: "chinchilla4.jpg", theme_id: 3, ave_value: 0 },
  { name: "Серый стандарт", file: "chinchilla5.jpg", theme_id: 3, ave_value: 0 }
]

images_pets = [
  { name: "Кролик", file: "pet1.jpg", theme_id: 4, ave_value: 0 },
  { name: "Крыса", file: "pet2.jpg", theme_id: 4, ave_value: 0 },
  { name: "Кошка", file: "pet3.jpg", theme_id: 4, ave_value: 0 },
  { name: "Попугайчик", file: "pet4.jpg", theme_id: 4, ave_value: 0 },
  { name: "Улитка", file: "pet5.jpg", theme_id: 4, ave_value: 0 }
]

all_images = images_fish + images_chinchilla + images_pets
Image.create!(all_images)
