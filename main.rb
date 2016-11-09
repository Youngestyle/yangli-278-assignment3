require 'sinatra'
require 'slim'
require 'sass'
require './student'

configure do
	enable :sessions
	set :username, "yuan"
	set :password, "wang"
end

get('/styles.css'){ scss :styles }

get '/' do
  slim :home
end

get '/about' do
  @title = "All About This Website"
  slim :about
end

get '/contact' do
  slim :contact
end

get '/login' do
	slim :login
end

post '/login' do
	if params[:username] == settings.username && params[:password] == settings.password
		session[:admin] = true
		redirect to ('/students')
	else
		session[:fail] = true
		slim :login
	end
end

get '/logout' do
	session.clear
	redirect to ('/login')
end


not_found do
  slim :not_found
end
