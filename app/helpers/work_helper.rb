module WorkHelper # Хелпер для подготовки данных изображения к передаче в JavaScript.
    def image_data(theme, data)
    {
      values_qty: data[:values_qty],
      theme: theme,
      current_user_id: data[:current_user_id],
      theme_id: data[:theme_id],
      index: data[:index],
      images_arr_size: data[:images_arr_size],
      image_id: data[:image_id],
      name: data[:name],
      file: data[:file],
      user_valued: data[:user_valued],
      value: data[:value],
      common_ave_value: data[:common_ave_value],
      image_url: data[:image_url] # Готовый URL для отображения картинки
    }
  end
end
