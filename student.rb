require 'sinatra'
require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_RED_URL'])
#DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/students.db")

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
