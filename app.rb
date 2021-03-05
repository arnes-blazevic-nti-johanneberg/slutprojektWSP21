require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require './model.rb'

enable :sessions

get('/') do
  slim(:"albums/index")
end

get('/showlogin') do #inte skapat denna ännu men det ska vara dit man kommer/behörigheten som man får om man lyckats logga in
  slim(:"albums/login")
end

post('/login') do
  username = params[:username]
  password = params[:password]
  db = SQLite3::Database.new('db/slutprojekt.db')
  db.results_as_hash = true
  result = db.execute('SELECT * FROM users WHERE username = ?', username).first
  pwdigest = result['password']
  id = result['id']

  if BCrypt::Password.new(password) == password
    session[:id] = id
    redirect('/hem') # inte klar med denna delen ännu, #inte skapat denna ännu men det ska vara dit man kommer/behörigheten som man får om man lyckats logga in
  else
    "Du har inte angett rätt lösenord"
  end

end

get("showregister") do
  slim(:albums/register)

post('/register') do
  username = params[:username]
  password = params[:password]
  password_confirm = params[:password_confirm]
  if (password == password_confirm)
    password_digest = BCrypt::Password.create(password)
    db = SQLite3::Database.new('db/slutprojekt.db')
    db.execute("INSERT INTO users (username,password) VALUES (?,?)", username, password)
    redirect("/hem") #inte klar denna delen ännu, #inte skapat denna ännu men det ska vara dit man kommer/behörigheten som man får om man lyckats logga in
  else
    "Lösenordet matchade inte!"
  end
end