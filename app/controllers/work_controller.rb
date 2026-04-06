class WorkController < ApplicationController
  include WorkImage
  include WorkHelper

  def index
    @images_count = Image.all.count
    @selected_theme = "Выберите тему для оценки"
    @selected_image_name = 'Вишневый барбус'               # временное значение
    @values_qty = Value.all.count
    @current_locale = I18n.locale
    session[:selected_theme_id] = @selected_theme   # заглушка
  end

  def choose_theme
    @themes = Theme.all.pluck(:name)
    respond_to :html, :js
  end

  def display_theme
    @image_data = {}
    I18n.locale = session[:current_locale] if session[:current_locale]

    current_user_id = current_user.id
    theme_param = params[:theme]

    if theme_param.blank? || theme_param == "-----"
      theme = "Выберите тему, чтобы дать свою оценку"
      theme_id = 1
      values_qty = Value.all.count.round
      data = {
        index: 0,
        name: 'Вишневый барбус',
        values_qty: values_qty,
        file: 'fish1.jpg',   
        image_id: 1,
        current_user_id: current_user_id,
        user_valued: false,
        common_ave_value: 0,
        value: 0,
        theme_id: theme_id,
        images_arr_size: 0
      }
    else
      theme = theme_param
      theme_record = Theme.find_by(name: theme)
      theme_id = theme_record.id if theme_record
      data = show_image(theme_id, 0)
    end

    session[:selected_theme_id] = theme_id
    @image_data = image_data(theme, data)
    respond_to :js

    # rescue => e
    # logger.error "ERROR in display_theme: #{e.message}\n#{e.backtrace.join("\n")}"
    # render plain: "error", status: 500
  end

  private

  # Вспомогательный метод для получения текущего пользователя
  def current_user
    # Временно: первый пользователь из базы
    @current_user ||= User.first || User.create!(name: "Guest", email: "guest@example.com")
  end
end
