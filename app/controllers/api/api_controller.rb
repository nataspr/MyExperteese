module Api
  class ApiController < ApplicationController
    include WorkImage  # модуль с методом show_image

    # Действие для следующего изображения
    def next_image
      current_index = params[:index].to_i # текущий индекс отображаемого изображения - строки в целые числа
      theme_id = params[:theme_id].to_i # ID выбранной темы
      length = params[:length].to_i # общее количество изображений в теме

      new_index = next_index(current_index, length) # новый индекс: если текущий не последний, то +1, иначе 0 (зацикливание)
      image_data = show_image(theme_id, new_index) # хэш с данными об изображении по новому индексу
 
      # Ответ в формате JSON 
      respond_to do |format|
        if image_data.blank?
          format.json { render json: { error: 'Image not found' }, status: :unprocessable_entity }
        else
          # Добавляем готовый URL картинки
          image_data[:image_url] = view_context.asset_path("pictures/#{image_data[:file]}") # view_context даёт доступ к хелперам представлений (например, asset_path)
          format.json do
            render json: {
              new_image_index: image_data[:index],  # новый индекс
              name: image_data[:name],
              file: image_data[:file],
              image_url: image_data[:image_url], # готовый URL для тега <img>
              image_id: image_data[:image_id],
              user_valued: image_data[:user_valued], # оценивал ли пользователь
              common_ave_value: image_data[:common_ave_value],
              value: image_data[:value], # оценка пользователя 
              status: :success,
              notice: 'Переключено на следующее изображение'
            }
          end
        end
      end
    end

    # Действие для предыдущего изображения
    def prev_image
      current_index = params[:index].to_i
      theme_id = params[:theme_id].to_i
      length = params[:length].to_i

      new_index = prev_index(current_index, length)
      image_data = show_image(theme_id, new_index)

      respond_to do |format|
        if image_data.blank?
          format.json { render json: { error: 'Image not found' }, status: :unprocessable_entity }
        else
          image_data[:image_url] = view_context.asset_path("pictures/#{image_data[:file]}")
          format.json do
            render json: {
              new_image_index: image_data[:index],
              name: image_data[:name],
              file: image_data[:file],
              image_url: image_data[:image_url],
              image_id: image_data[:image_id],
              user_valued: image_data[:user_valued],
              common_ave_value: image_data[:common_ave_value],
              value: image_data[:value],
              status: :success,
              notice: 'Переключено на предыдущее изображение'
            }
          end
        end
      end
    end

    private

    def next_index(index, length)
      index < length - 1 ? index + 1 : 0
    end

    def prev_index(index, length)
      index > 0 ? index - 1 : length - 1
    end
#из-за подкотовке к аутентиф был метод current_user в  модуле WorkImage
# Этот метод не определён в Api::ApiController, тогда как в обычном WorkController он есть
# ошибка перелистывания - ИСПРАВИТЬ!!! при аутентификации
    def current_user
      @current_user ||= User.first || User.create!(name: "Guest", email: "guest@example.com")
    end
  end
end