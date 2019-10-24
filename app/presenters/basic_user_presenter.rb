class BasicUserPresenter < Presenter
  will_print :email, :jwt

  def jwt
    user.session.token
  end
end
