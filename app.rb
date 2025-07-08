require_relative 'watchlist'

def generate_watch_link(title, year)
  slug = title.downcase.gsub(/[^a-z0-9\s]/, '').strip.gsub(/\s+/, '-')
  "https://www.lookmovie2.to/movies/view/#{slug}-#{year}"
end

watchlist = Watchlist.new('movies.csv')

def display_menu
  puts "\n🎬 #{'=' * 30}"
  puts "📽️  Movie Watchlist Manager"
  puts "#{'=' * 30}"
  puts "1️⃣  Add Movie"
  puts "2️⃣  Update Movie"
  puts "3️⃣  Delete Movie"
  puts "4️⃣  Display All Movies"
  puts "5️⃣  Display Movies by Genre"
  puts "6️⃣  Exit"
  print "\n👉 Choose an option (1–6): "
end

loop do
  display_menu
  choice = gets.chomp.to_i
  case choice
  when 1
    title = nil
    loop do
      print 'Enter title: '
      title = gets.chomp
      break if title.is_a?(String) && !title.strip.empty? && title.length <= 20 && !title.match(/[^a-zA-Z\s]+/) 
      puts "❌ Invalid title. Must be a string, 1–20 characters, only letters and spaces."
    end

    genre = nil
    loop do
      print 'Enter genre: '
      genre = gets.chomp
      break if ["Action", "Comedy", "Romance","action","comedy","romance"].include?(genre)
      puts "❌ Invalid genre. Must be one of Action, Comedy, or Romance."
    end

    status = nil
    loop do
      print 'Enter status: '
      status = gets.chomp
      break if ["to_watch", "watching","watched"].include?(status)
      puts "❌ Invalid status. Must be 'to_watch', 'watching', or 'watched'."
    end

    rating = nil
    print 'Enter rating (optional): '
    rating_str = gets.chomp
    rating = rating_str.empty? ? nil : rating_str.to_i
    if rating
      loop do
        break if rating.is_a?(Integer) && rating >= 1 && rating <= 5
        puts "❌ Invalid rating. Must be an integer between 1 and 5."
        print 'Enter rating (optional): '
        rating_str = gets.chomp
        rating = rating_str.empty? ? nil : rating_str.to_i
        break if rating == nil
      end
    end
    print 'Enter release year: '
    year = gets.chomp.to_i
    link = generate_watch_link(title, year)
    watchlist.add_movie(title, genre, status, rating, year, link)


    
      
  when 2
    title = nil
    loop do
      print 'Enter title: '
      title = gets.chomp
      break if title.is_a?(String) && !title.strip.empty? && title.length <= 20 && !title.match(/[^a-zA-Z\s]+/)
      puts "❌ Invalid title. Must be a string, 1–20 characters, only letters and spaces."
    end

    rating = nil
    loop do
      print 'Enter new rating: '
      rating = gets.chomp.to_i
      break if rating.is_a?(Integer) && rating >= 1 && rating <= 5
      puts "❌ Invalid rating. Must be an integer between 1 and 5."
    end
      
    status = nil
    loop do
      print 'Enter new status: '
      status = gets.chomp
      break if ["to_watch","watching","watched"].include?(status)
      puts "❌ Invalid status. Must be 'to_watch', 'watching', or 'watched'."
    end

    genre = nil
    loop do
      print 'Enter new genre: '
      genre = gets.chomp
      break if ["Action", "Comedy", "Romance","action","comedy","romance"].include?(genre)
      puts "❌ Invalid genre. Must be one of Action, Comedy, or Romance."
    end
    watchlist.update_movie(title, rating, status, genre)
  when 3
    title = nil
    loop do
      print 'Enter title: '
      title = gets.chomp
      break if title.is_a?(String) && !title.strip.empty? && title.length <= 20 && !title.match(/[^a-zA-Z\s]+/)
      puts "❌ Invalid title. Must be a string, 1–20 characters, only letters and spaces."
    end
    watchlist.delete_movie(title)
  when 4
    watchlist.display_movies
  when 5
    genre = nil
    loop do
      print 'Enter genre: '
      genre = gets.chomp
      break if ["Action", "Comedy", "Romance","action","comedy","romance"].include?(genre)
      puts "❌ Invalid genre. Must be one of Action, Comedy, or Romance."
    end
    watchlist.display_movies(genre)
  when 6
    puts 'Goodbye!'
    break
  else
    puts 'Invalid choice. Please try again.'
  end
end
