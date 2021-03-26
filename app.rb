require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require './model.rb'

enable :sessions

get('/') do
  slim(:"index")
end

get('/showlogin') do #inte skapat denna ännu men det ska vara dit man kommer/behörigheten som man får om man lyckats logga in
  slim(:"login")
end

# "get('/homepage') do 
  #"slim(:"hem",locals:{books_read:result})

#end

post('/login') do
  #if session[:now]
    #time = session[:now].split("_")
    #if Time.new(time[0], time[1], time[2], time[3], time[4], time[5]) > (Time.now - 300)
       # set_error("Du måste 5 minuter tills du får försöka igen, bättre lycka till nästa gång")
       # redirect("/error")
    #end
#end



  username = params[:username]
  password = params[:password]
  db = SQLite3::Database.new("db/slutprojekt.db") #?????scbpro????
  db.results_as_hash = true
  result = db.execute("SELECT * FROM users WHERE username = ?", username).first
  pwdigest = result["pw_digest"]
  id = result["id"]

  if BCrypt::Password.new(pwdigest) == password
    session[:id] = id
    redirect("/books_read") # inte klar med denna delen ännu, #inte skapat denna ännu men det ska vara dit man kommer/behörigheten som man får om man lyckats logga in
  else
    "Du har inte angett rätt lösenord"
  end
end

get("/showregister") do
  slim(:"register")
end

post('/users') do
  username = params[:username]
  password = params[:password]
  password_confirm = params[:password_confirm]
  if (password == password_confirm)
    password_digest = BCrypt::Password.create(password)
    db = SQLite3::Database.new("db/slutprojekt.db") #??????scbpro????
    db.execute("INSERT INTO users (username, pw_digest) VALUES (?,?)", username, password_digest)
    redirect("/homepage") #inte klar denna delen ännu, #inte skapat denna ännu men det ska vara dit man kommer/behörigheten som man får om man lyckats logga in
  else
    "Lösenordet matchade inte!"
  end
end

get("/books_read") do
  id = session[:id].to_i #kopplar till databas och hämtar info om vem som är inloggad
  db = SQLite3::Database.new('db/slutprojekt.db')
  db.results_as_hash = true
  result = db.execute("SELECT * FROM books_read WHERE user_id = ?",id)    #osäker på just denna kopplingen till databasen, använda min många till många relation här?
  p "Alla dina lästa bäcker från result #{result}" #använda min många till många relation här? books_title & users relationen
  slim(:"hem",locals:{books_read:result})
end

post('/books_read/delete') do
  id = params[:number]
  user_id = session[:id].to_i
  db = SQLite3::Database.new('db/slutprojekt.db')
  db.execute("DELETE FROM books_read WHERE id = ?", id)
  redirect('/books_read')
end

post('/books_read/new') do
  content = params[:content]
  userid = session[:id].to_i
  db = SQLite3::Database.new('db/slutprojekt.db')
  db.results_as_hash = true
  db.execute("INSERT INTO books_read (content) VALUES (?,)",books_read)
  redirect('/books_read')
end


#jag vill sedan att man ska kunna söka efter böcker och hitta liknande böcker, 