get "/login" do
  erb :"sessions/login", layout: false
end

post "/login" do
  @user = User.find_by(email: params[:email])

  if @user && @user.authenticate(params[:password])
    session[:user_id] = @user.id
    redirect "/"
  else
    erb :"sessions/login", layout: false
  end
end

get "/logout" do
  session[:user_id] = nil
  redirect "/"
end
