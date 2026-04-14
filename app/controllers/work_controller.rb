class WorkController < ApplicationController
  include WorkImage
  include WorkHelper
  # Главная страница рабочей области. Устанавливает начальные значения:
  # - количество всех изображений
  # - текст-заглушка для темы и имени изображения
  # - количество оценок (Value)
  # - текущая локаль (для будущей интернационализации)
  def index
    @images_count = Image.all.count
    @selected_theme = "Выберите тему для оценки"
    @selected_image_name = 'Вишневый барбус'
    @values_qty = Value.all.count
    @current_locale = I18n.locale
    session[:selected_theme_id] = @selected_theme
  end
 # Возвращает массив имён тем для заполнения выпадающего списка.
  def choose_theme
    @themes = Theme.all.pluck(:name)
    respond_to :html, :js # Ответ отправляется в формате JavaScript (JS.ERB) для динамической замены кнопки на форму
  end
  # Отображает первое изображение выбранной темы. Вызывается после отправки формы выбора темы.
  # Параметр :theme передаётся из select_tag.
  def display_theme
    @image_data = {}
    #I18n.locale = session[:current_locale] if session[:current_locale] # на будущую локализацию

    current_user_id = current_user.id
    theme_param = params[:theme]
    # Обработка случая, когда выбрана тема-заглушка "-----" 
    if theme_param.blank? || theme_param == "-----"
      theme = "Выберите тему, чтобы дать свою оценку"
      theme_id = 1
      values_qty = Value.all.count.round
      default_file = 'fish1.jpg'
      data = {
        index: 0,
        name: 'Вишневый барбус',
        values_qty: values_qty,
        file: default_file,
        image_id: 1,
        current_user_id: current_user_id,
        user_valued: false,
        common_ave_value: 0,
        value: 0,
        theme_id: theme_id,
        images_arr_size: 0,
        image_url: view_context.asset_path("pictures/#{default_file}")
      }
    else
      theme = theme_param
      theme_record = Theme.find_by(name: theme)
      theme_id = theme_record.id if theme_record
      # Вызов метода модуля WorkImage для получения данных первого изображения (индекс 0)
      data = show_image(theme_id, 0)
      if data.nil? # Если изображений нет – показываем заглушку
        data = {
          index: 0, name: 'Нет изображений', values_qty: 0,
          file: 'fish1.jpg', image_id: 1, current_user_id: current_user_id,
          user_valued: false, common_ave_value: 0, value: 0,
          theme_id: theme_id, images_arr_size: 0,
          image_url: view_context.asset_path("pictures/fish1.jpg")
        }
      else
         # полный URL изображения через asset pipeline
        data[:image_url] = view_context.asset_path("pictures/#{data[:file]}")
      end
    end

    session[:selected_theme_id] = theme_id # на будущее - не работает
    @image_data = image_data(theme, data) # Преобразуем данные в формат, ожидаемый представлением, через хелпер
    respond_to :js
  end

  private

  def current_user
    @current_user ||= User.first || User.create!(name: "Guest", email: "guest@example.com") # На время разработки используется первый пользователь из базы
  end
end