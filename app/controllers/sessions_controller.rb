class SessionsController < ApplicationController
  def new
  end

  def create
    if params[:session].blank?
      redirect_to signin_path, alert: "Пожалуйста, введите email и пароль"
      return
    end

    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to work_url
    else
      flash.now[:alert] = 'Неверный email/пароль'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
