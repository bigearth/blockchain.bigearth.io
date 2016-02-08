Resque::Server.use(Rack::Auth::Basic) do |username, password|
  username == Figaro.env.resque_web_username
  password == Figaro.env.resque_web_password
end
