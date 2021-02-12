require "sinatra"
require "slim"
require "sqlite3"
require "bcrypt"
require "byebug"
require_relative 'model.rb'

enable :sessions

db = SQLite3::Database.new("db/slutprojekt.db")
db.results_as_hash = true

get('/') do
    slim(:register)
  end
