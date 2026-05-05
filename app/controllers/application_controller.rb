class ApplicationController < ActionController::Base
  include SessionsHelper
 # to see in views and controllers
  before_action :set_locale

  private

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
    Rails.application.routes.default_url_options[:locale] = I18n.locale
  end

  def extract_locale
    if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
      params[:locale].to_sym
    else
      nil
    end
  end

  # Чтобы ссылки не теряли параметр locale, переопределим url_for
  def default_url_options
    { locale: I18n.locale }
  end
end
