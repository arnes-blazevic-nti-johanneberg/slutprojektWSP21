require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require './model.rb'

enable :sessions

# This is a important function thath checks before you do anything if yout seasion id or your request path is allowed to proceed further into the webbsite.
# This function is important becouse it makes it much harder to hack yoursekf throuth the webbsites with help of the browser, before block blocks this method
before do 
  if (session[:id] ==  nil) && (request.path_info != '/') && (request.path_info != '/showlogin' && (request.path_info != '/showregister') && (request.path_info != '/login') && (request.path_info != '/users/new'))
    redirect("/")
  end
end

# If something goes wrong in the website it slims a error website that explain what went wrong
get("/error") do
  slim(:error)
end


#get('/') do
 # if (session[:id] !=  nil)
#    redirect("books_read")
#  else
#    slim(:"index")
#  end
#end

# This is the first website that show when opening the website
#it checks if you already are loged in and if you are you are redirected to "books_read" sinde you already have your seasion id
#if you are not already logged in then it slims and sends you to "index" wher you either may loggin or register a account
get ('/') do
    if already_logged_in() == true
        db = connect_to_db("db/slutprojekt.db")
        result = db.execute("SELECT * FROM books_read")
        redirect("books_read")
    else
        # session[:error] = nil
        slim(:"/index")
    end
end

# checks if you have a youser Id and if you do it sends you to the main page ("books_read"), and if you dont habe a seasion id it redirects you to and slims user/login, where you have to login and get a seasion id to be able to enter the rest of the website
get('/showlogin') do #inte skapat denna ännu men det ska vara dit man kommer/behörigheten som man får om man lyckats logga in
  if (session[:id] !=  nil)
    redirect("books_read")
  else
    slim(:"users/login")
  end
end
# Slims and sends you to and displays the main page where alla your books are shown for you
get('/homepage') do 
  slim(:"index",locals:{books_read:result})
end


# Attempts to login a user.
# if users inputed password matches with the databases it gets you your seasion:id and you may proced further in the website and gets redirected to ("books_read")
# else you will get redirected to ("/") where you may either login or create an account to gain a seasion:id
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

# Attempts to logout a user.
#
# Trieys to destroy the users seasion which becouse of my before do funktions thath checks if seasion id = nill, therefore it kicks you out from the side to the "/"
get("/logout") do
  session.destroy
  redirect("/")
end
# Checks if you you already have a seassion id, if it is not nill it sends you to the main page ("books_read")
# Else it slims a users/register where you may register and get a seassion id and mover further into the webbsite
get("/showregister") do
  if (session[:id] !=  nil)
    redirect("books_read")
  else
    slim(:"users/register")
  end
end

# Attempts to register a user.
post('/users/new') do
  username = params[:username]
  password = params[:password]
  password_confirm = params[:password_confirm]          #fixat model på denna
  register(username, password, password_confirm)
end

# pots all the books thath is owned by the user (session[:id]), you may at this page only see your own books
# if your seasion id works, it gets all of the books thath belonges to the user from the database
# else it just redirect the user to ("/") wher you either have to register or login to gain an seasion:id and be able to proceed furter into the webbsite
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


# Deletes books, only able to delete the books that belong to your user_id
post('/books_read/delete') do
  id = params[:number]  # skapa en if sats om man kommer in med rätt inlgogning
  user_id = session[:id].to_i
  delete_post(id)                             # Gjort model.rb på denna
  redirect('/books_read')
end

# makes new books, only able to make new books that will belong to your user_id
post('/books_read/new') do
  content = params[:content]
  genre_id = params[:genre_id]              # Gjort model.rb på denna
  user_id = session[:id].to_i
  p "Inloggad har id #{user_id}"
  new_post(content, user_id, genre_id)
  redirect('/books_read')
end
# edits your already owned books, you may only edit the name and not the genre, if you want to change the genre you unfortenetly have to delete the book and make a new one
post('/books_read/edit') do
  content = params[:content]
  id = params[:number]
  user_id = session[:id].to_i             # Gjort model.rb på denna
  update_post(content, id)
  redirect('/books_read')
end


# gets all of the genres thath are listen in the database and posts the on the webbsite
get("/books/findbooks/index") do
  db = SQLite3::Database.new('db/slutprojekt.db')
  db.results_as_hash = true
  result = db.execute("SELECT * FROM genre" )
  slim(:"books/findbooks/index",locals:{genre:result})
end

# allows you to chose which genre you want to search for and find new books about to read, you get to see all of the books thath have the same genre thath other users have read
post("/books/findbooks/index") do
  genre_id = params[:genre_name]
  session[:genre_id] = genre_id
  puts "#{genre_id}"                                #Gjort model på denna
  result = find_new_books(genre_id)
  slim(:"books/findbooks/index",locals:{genre:result})          
  redirect("/books/findbooks:genre_id") #jag vill nog bli redirectat till ny sida som visar all denna infon med vald informaiton
end

# based on the genre_id it posts all of the books in the database that have matching genre_id with the users chosen one
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