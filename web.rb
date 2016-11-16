require 'sinatra'
require 'slim'
require 'sass'
require 'dm-core'
require 'dm-migrations'



class Student
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :description, Text
  property :height, Integer
  property :dob, Date
  
  def released_on=date
    super Date.strptime(date, '%m/%d/%Y')
  end
end

DataMapper.finalize

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
		session[:name] = params[:username]
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



get '/students' do
  halt slim :login unless session[:admin]
  @students = Student.all
  slim :students
end

get '/students/new' do
  halt slim :login unless session[:admin]
  @student = Student.new
  slim :new_student
end

get '/students/:id' do
  halt slim :login unless session[:admin]
  @student = Student.get(params[:id])
  slim :show_student
end

get '/students/:id/edit' do
  halt slim :login unless session[:admin]
  @student = Student.get(params[:id])
  slim :edit_student
end

post '/students' do  
  halt slim :login unless session[:admin]
  student = Student.create(params[:student])
  redirect to("/students/#{student.id}")
end

put '/students/:id' do
  halt slim :login unless session[:admin]
  student = Student.get(params[:id])
  student.update(params[:student])
  redirect to("/students/#{student.id}")
end

delete '/students/:id' do
  halt slim :login unless session[:admin]
  Student.get(params[:id]).destroy
  redirect to('/students')
end


not_found do
  slim :not_found
end
