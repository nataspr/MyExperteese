module WorkImage
  extend ActiveSupport::Concern

  # Метод для получения данных об изображении по индексу в массиве изображений темы
  def show_image(theme_id, image_index)
    theme_images = Image.theme_images(theme_id)
    return nil if theme_images.empty? || image_index >= theme_images.size

    current_user_id = current_user.id
    one_image_attr = theme_images[image_index].attributes
    image_id = one_image_attr['id']

    user_valued, value = Value.user_valued_exists(current_user_id, image_id)
    values_qty = Value.all.count.round

    if user_valued
      common_ave_value = Image.find(image_id).ave_value.to_f.round
      common_ave_value = 0 if common_ave_value.blank?
    else
      common_ave_value = 0
    end

    {
      index: image_index,
      values_qty: values_qty,
      current_user_id: current_user_id,
      theme_id: theme_id,
      images_arr_size: theme_images.size,
      image_id: image_id,
      name: one_image_attr['name'],
      file: one_image_attr['file'],
      user_valued: user_valued,
      value: value,
      common_ave_value: common_ave_value
    }
  end
end