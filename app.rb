require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require './model.rb'

enable :sessions


before do 
  if (session[:id] ==  nil) && (request.path_info != '/') && (request.path_info != '/showlogin' && (request.path_info != '/showregister') && (request.path_info != '/login') && (request.path_info != '/users/new'))
    redirect("/")
  end
end


get("/error") do
  slim(:error)
end


get('/') do
  if (session[:id] !=  nil)
    redirect("books_read")
  else
    slim(:"index")
  end
end



get('/showlogin') do #inte skapat denna ännu men det ska vara dit man kommer/behörigheten som man får om man lyckats logga in
  if (session[:id] !=  nil)
    redirect("books_read")
  else
    slim(:"users/login")
  end
end

get('/homepage') do 
  slim(:"index",locals:{books_read:result})
end

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
  result = login(username, password)          
  pwdigest = result["pw_digest"]
  id = result["id"]

  if BCrypt::Password.new(pwdigest) == password
    puts "hej"
    session[:id] = id
    redirect("/books_read") # inte klar med denna delen ännu, #inte skapat denna ännu men det ska vara dit man kommer/behörigheten som man får om man lyckats logga in
  else
    "Du har inte angett rätt lösenord"
    redirect("/")
  end
end

get("/logout") do
  session[:id] = nil
  redirect("/")
end

get("/showregister") do
  if (session[:id] !=  nil)
    redirect("books_read")
  else
    slim(:"users/register")
  end
end

post('/users/new') do
  username = params[:username]
  password = params[:password]
  password_confirm = params[:password_confirm]          #fixat model på denna
  register(username, password, password_confirm)
end

get("/books_read") do
  if  id = session[:id].to_i #kopplar till databas och hämtar info om vem som är inloggad
    puts "test"
    db = SQLite3::Database.new('db/slutprojekt.db')
    db.results_as_hash = true
    result = db.execute("SELECT * FROM books_read WHERE user_id = ?",id)    #osäker på just denna kopplingen till databasen, använda min många till många relation här? #lyckades inte fixa model på denna
    result2 = db.execute("SELECT * FROM genre" )
    p "Alla dina lästa bäcker från result #{result}" #använda min många till många relation här? books_title & users relationen
    slim(:"books/index",locals:{books_read:result, genre:result2})
  else 
    redirect('/') #gjorde detta
  end
end



post('/books_read/delete') do
  id = params[:number]  # skapa en if sats om man kommer in med rätt inlgogning
  user_id = session[:id].to_i
  delete_post(id)                             # Gjort model.rb på denna
  redirect('/books_read')
end

post('/books_read/new') do
  content = params[:content]
  genre_id = params[:genre_id]              # Gjort model.rb på denna
  user_id = session[:id].to_i
  p "Inloggad har id #{user_id}"
  new_post(content, user_id, genre_id)
  redirect('/books_read')
end

post('/books_read/edit') do
  content = params[:content]
  id = params[:number]
  user_id = session[:id].to_i             # Gjort model.rb på denna
  update_post(content, id)
  redirect('/books_read')
end

get("/books/findbooks/index") do
  db = SQLite3::Database.new('db/slutprojekt.db')
  db.results_as_hash = true
  result = db.execute("SELECT * FROM genre" )
  slim(:"books/findbooks/index",locals:{genre:result})
end


post("/books/findbooks/index") do
  genre_id = params[:genre_name]
  session[:genre_id] = genre_id
  puts "#{genre_id}"                                #Gjort model på denna
  result = find_new_books(genre_id)
  slim(:"books/findbooks/index",locals:{genre:result})          
  redirect("/books/findbooks:genre_id") #jag vill nog bli redirectat till ny sida som visar all denna infon med vald informaiton
end

get("/books/findbooks:genre_id") do #jag vill skapa en ny sida som visar vald genre från förra sidan
  genre_id = session[:genre_id]                                    #Gjort model på denna
  result = find_new_books_genres()
  slim(:"books/findbooks/show",locals:{books_read:result})
end




# väljer en bok av alternativen som kommer fram och sedan lägger till den till min privata lista med böcker som jag har läst
# content = params[:content]
# genre_id = params[:genre_id]
#user_id = session[:id]
#db.execute("INSERT INTO books_read (content, user_id, genre_id) VALUES (?,?,?)", content, user_id, genre_id)




# Visar alla användare som har en specifik bok för att få till många till många situation där 1 bok kan ha flera ägare

# select * user_id som har samma bok ID'


# göra om mina tabbeller där flera personer kan läsa samma bok och inte har varsinn.

# Fixa så att min before Do faktiskt funkar då den just nu verkar bugga och endast godkänner vissa sidor men itne alla

# Skapa så att man kan ha en Admin roll så att den kan komma åt alla perssoner info