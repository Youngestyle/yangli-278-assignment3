require 'sinatra'
require 'slim'
require 'sass'


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