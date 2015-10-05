module RequestMacros
  def request_login_user
    before(:each) do
      @loginuser = FactoryGirl.create(:login_user)
      post_via_redirect user_session_path, 'user[login]': @loginuser.login, 'user[password]': @loginuser.password
    end
  end

  def request_admin_user
    before(:each) do
      @loginuser = FactoryGirl.create(:login_user)
      post_via_redirect user_session_path, 'user[login]': @loginuser.login, 'user[password]': @loginuser.password
    end
  end
end
