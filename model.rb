def connect_to_db(path)
    db = SQLite3::Database.new(path)
    db.results_as_hash = true
    return db
end

def update_post(content, id)
    db = connect_to_db("db/slutprojekt.db")
    db.execute("UPDATE books_read SET content = ? WHERE id = ?", content, id)
end


def delete_post(id)
    db = connect_to_db("db/slutprojekt.db")
    db.execute("DELETE FROM books_read WHERE id = ?", id)
end


def new_post(content, user_id, genre_id)
    db = connect_to_db("db/slutprojekt.db")
    db.execute("INSERT INTO books_read (content, user_id, genre_id) VALUES (?,?,?)", content, user_id, genre_id)
end





def login(username, password)
        db = SQLite3::Database.new("db/slutprojekt.db")
        db.results_as_hash = true
        result = db.execute("SELECT * FROM users WHERE username = ?", username).first
        return result
end


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

def find_new_books(genre_id)
    db = SQLite3::Database.new('db/slutprojekt.db')
    db.results_as_hash = true
    result = db.execute("SELECT * FROM books_read WHERE genre_id = ?",genre_id)
    return result
end



def find_new_books_genres()
    genre_id = session[:genre_id] 
    db = SQLite3::Database.new('db/slutprojekt.db')
    db.results_as_hash = true
    result = db.execute("SELECT * FROM books_read WHERE genre_id = ?",genre_id)   #id #osäker hur detta blir/ska fungera
    return result
end

    

def login(username, password)  
    db = SQLite3::Database.new("db/slutprojekt.db") #?????scbpro????
    db.results_as_hash = true
    result = db.execute("SELECT * FROM users WHERE username = ?", username).first
    return result
end

def already_logged_in()
    if session[:id] != nil
      return true
    else
      return false
    end
end






