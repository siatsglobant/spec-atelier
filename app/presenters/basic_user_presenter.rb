class BasicUserPresenter < Presenter
  will_print :id, :email, :jwt, :first_name, :last_name, :birthday, :office, :profile_image

  def jwt
    user.session.token rescue 'not logged in'
  end
end
