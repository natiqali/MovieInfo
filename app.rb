require_relative 'watchlist'
require_relative 'users'

users_db = UsersDatabase.new

# 👤 Login Prompt
user = nil
loop do
  puts "Welcome! Please log in."

  print "Username: "
  username = gets.chomp.strip

  print "Role (guest/member): "
  role = gets.chomp.strip.downcase

  password = nil
  if role == "member"
    print "Password: "
    password = gets.chomp
  end

  user = users_db.login(username, role, password)
  if user
    break
  else
    puts "❌ Login failed. Please try again."
  end
end

watchlist = Watchlist.new('movies.csv')

def display_menu
  puts "\n🎬 #{'=' * 30}"
  puts "🎩  \e[1mMovie Watchlist Manager\e[0m"
  puts "#{'=' * 30}"
  puts "1⃣  Add Movie"
  puts "2⃣  Update Movie"
  puts "3⃣  Delete Movie"
  puts "4⃣  Display All Movies"
  puts "5⃣  Display Movies by Genre"
  puts "6⃣  Search Movie Database"
  puts "7⃣  Exit"
  print "\n👉 \e[1mChoose an option (1–7):\e[0m "
end

loop do
  display_menu
  choice = gets.chomp.to_i

  case choice
  when 1
    puts "\n🎬 Adding a new movie to your watchlist"
    print "🎬 Enter movie title: "
    title = gets.chomp.strip

    print "🎭 Enter genre (Action, Comedy, Romance): "
    genre = gets.chomp.strip.downcase

    print "🎯 Enter status (to_watch / watching / watched): "
    status = gets.chomp.strip.downcase

    print "⭐ Enter rating (optional, press Enter to skip): "
    rating_input = gets.chomp
    rating = rating_input.empty? ? nil : rating_input.to_f

    puts "\n🔍 Searching for movie in database..."
    movie_info = watchlist.find_and_generate_link(title, user)

    watchlist.add_movie(
      title,
      genre,
      status,
      rating,
      movie_info[:year],
      movie_info[:link]
    )

  when 2
    print "🎬 Enter title to update: "
    title = gets.chomp

    print "⭐ Enter new rating (1–5): "
    rating = gets.chomp.to_f

    print "🎯 Enter new status (to_watch / watching / watched): "
    status = gets.chomp

    print "🎭 Enter new genre (Action, Comedy, Romance): "
    genre = gets.chomp

    watchlist.update_movie(title, rating, status, genre)

  when 3
    print "🎬 Enter title to delete: "
    title = gets.chomp
    watchlist.delete_movie(title)

  when 4
    watchlist.display_movies(nil, user)

  when 5
    print "🎭 Enter genre to display: "
    genre = gets.chomp
    watchlist.display_movies(genre, user)

  when 6
    print "🎬 Enter movie title to search: "
    search_title = gets.chomp
    movie_info = watchlist.find_and_generate_link(search_title, user)

    if movie_info[:year]
      if movie_info[:link]
        puts "🎬 Watch link: #{movie_info[:link]}"
      else
        puts "🔒 Only members can view watch links."
      end
    else
      puts "❌ Movie not found in database."
    end

  when 7
    puts "👋 Goodbye!"
    break

  else
    puts "❌ Invalid choice. Please enter a number from 1 to 7."
  end
end
