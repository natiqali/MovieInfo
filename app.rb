require_relative 'watchlist'

watchlist = Watchlist.new('movies.csv')

def display_menu
  puts "\n🎬 Movie Watchlist Manager"
  puts '1. Add Movie'
  puts '2. Update Movie'
  puts '3. Delete Movie'
  puts '4. Display All Movies'
  puts '5. Display Movies by Genre'
  puts '6. Exit'
  print 'Choose an option (1-6): '
end

loop do
  display_menu
  choice = gets.chomp
               .to_i
  case choice
  when 1
    print 'Enter title: '
    title = gets.chomp
    print 'Enter genre: '
    genre = gets.chomp
    print 'Enter status: '
    status = gets.chomp
    print 'Enter rating (optional): '
    rating = gets.chomp
    rating = rating.empty? ? nil : rating.to_i
    watchlist.add_movie(title, genre, status, rating)
  when 2
    print 'Enter title: '
    title = gets.chomp
    print 'Enter new rating: '
    rating = gets.chomp.to_i
    print 'Enter new status: '
    status = gets.chomp
    print 'Enter new genre: '
    genre = gets.chomp
    watchlist.update_movie(title, rating, status, genre)
  when 3
    print 'Enter title: '
    title = gets.chomp
    watchlist.delete_movie(title)
  when 4
    watchlist.display_movies
  when 5
    print 'Enter genre: '
    genre = gets.chomp
    watchlist.display_movies(genre)
  when 6
    puts 'Goodbye!'
    break
  else
    puts 'Invalid choice. Please try again.'
  end
end
