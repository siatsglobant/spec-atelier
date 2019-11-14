class BasicUserPresenter < Presenter
  will_print :id, :email, :jwt

  def jwt
    user.session.token
  end
end
