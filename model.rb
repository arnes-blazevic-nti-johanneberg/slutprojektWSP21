def db()
    db = SQLite3::Database.new("db/slutprojekt.db")
    db.results_as_hash = true
    return db
end