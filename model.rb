# connects to database
# @param [sting] connects the path to the database and get you the right information
def connect_to_db(path)
    db = SQLite3::Database.new(path)
    db.results_as_hash = true
    return db
end
# Updates your posts
# @param [String] content the books name based on what the user puts in
# @param [String] book id every book gets an book id
def update_post(content, id)
    db = connect_to_db("db/slutprojekt.db")
    db.execute("UPDATE books_read SET content = ? WHERE id = ?", content, id)
end

# Deletes books
#
# @param [integrer] book id the chosen object will be deleted based on the id (object) chosen by the user, it is aswll locked to the user_id
# @param [string] changes the name of the book, only the user may do thath
def delete_post(id)
    db = connect_to_db("db/slutprojekt.db")
    db.execute("DELETE FROM books_read WHERE id = ?", id)
end

# Makes new books
#
# @param [String] content the books name based on what the user puts in
# @param [String] genre_id every book gets an genre id based on the selection by the user
# @param [String] user_id every book when crafted gets a uniquq user_id that diffences the book from every other book 
def new_post(content, user_id, genre_id)
    db = connect_to_db("db/slutprojekt.db")
    db.execute("INSERT INTO books_read (content, user_id, genre_id) VALUES (?,?,?)", content, user_id, genre_id)
end


# Attempts to register a user.
#
# @param [String] username The username inputted by the user.
# @param [String] password The password inputted by the user.
# @param [String] password_confirm The password_confirm inputted by the user, and checks if the inputed password matches with the inputed password_digest.
def register(username, password, password_confirm)
    if (password == password_confirm)
        password_digest = BCrypt::Password.create(password)
        db = SQLite3::Database.new("db/slutprojekt.db") #??????scbpro????
        db.execute("INSERT INTO users (username, pw_digest) VALUES (?,?)", username, password_digest)
        redirect("/books_read") #inte klar denna delen ännu, #inte skapat denna ännu men det ska vara dit man kommer/behörigheten som man får om man lyckats logga in
    else
        set_error("Lösenordet matchade inte!, backa och försökt igen")
        redirect("/error")
    end
end

# is the webbsite whre you chose your preferd genre to find books thath match the genre
# @param [string] genre_is, when you chose your preferd genre it changes the genre id to the specific genre you have chosen

def find_new_books(genre_id)
    db = SQLite3::Database.new('db/slutprojekt.db')
    db.results_as_hash = true
    result = db.execute("SELECT * FROM books_read WHERE genre_id = ?",genre_id)
    return result
end


# This is the webbsite wher based on yout schosen genre_id from the page before you will get all the books that matches with with the chosen genre_id
# genre_id = session[:genre_id] the id thath every genre has, every genre has its own unique id
def find_new_books_genres()
    genre_id = session[:genre_id] 
    db = SQLite3::Database.new('db/slutprojekt.db')
    db.results_as_hash = true
    result = db.execute("SELECT * FROM books_read WHERE genre_id = ?",genre_id)   #id #osäker hur detta blir/ska fungera
    return result
end

    
# Attempts to login a user.
#
# @param [String] username The username inputted by the user.
# @param [String] password The password inputted by the user.
def login(username, password)  
    db = SQLite3::Database.new("db/slutprojekt.db") #?????scbpro????
    db.results_as_hash = true
    result = db.execute("SELECT * FROM users WHERE username = ?", username).first
    return result
end


# Checks if a user is already logged in.
#
# * :id [Integer] The ID of the user
# @return [True] if user is already logged in.
# @return [False] if user is not logged in.
def already_logged_in()
    if session[:id] != nil
      return true
    else
      return false
    end
end






