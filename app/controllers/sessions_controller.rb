class SessionsController < ApplicationController
  def new

  end

  def create
    # haetaan käyttäjä tietokannasta usernamen avulla
    user = User.find_by username: params[:username]
    # Jos käyttäjätunnusta ei ole
    if user && user.authenticate(params[:password])
      if user.access == false
        redirect_to :back, notice: "Your account is frozen, please contact admin!"
        return
      end
      # talletetaan sessioon käyttäjän id
      session[:user_id] = user.id
      # ohjataan käyttäjä omalle sivulleen
      redirect_to user_path user, notice: "Welcome back!"
    else
      redirect_to :back, notice: "Username and/or password mismatch!"
    end
  end

  def destroy
    # session nollaus
    session[:user_id] = nil
    # uudelleenohjaus sovelluksen oletussivulle
    redirect_to :root
  end
end