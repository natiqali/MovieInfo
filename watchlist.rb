# watchlist.rb
require_relative 'movies'
require_relative 'storage'

class Watchlist
  def initialize(filename)
    @filename = filename
    @movies = Storage.load_movies(filename)
  end

  def add_movie(title, genre, status, rating = nil)
    if !title.is_a?(String) || title.strip.empty? || title.length > 20 || title.match(/[^a-zA-Z\s]/)
      puts "❌ Invalid title. Must be a string, 1–20 characters, only letters and spaces."
      return
    end

    unless ["Action", "Comedy", "Romance"].include?(genre)
      puts "❌ Invalid genre. Choose from: Action, Comedy, Romance."
      return
    end

    unless ["to_watch", "watching", "watched"].include?(status)
      puts "❌ Invalid status. Must be 'to_watch', 'watching', or 'watched'."
      return
    end

    if rating && (!rating.is_a?(Integer) || rating < 1 || rating > 5)
      puts "❌ Invalid rating. Must be an integer between 1 and 5."
      return
    end

    if @movies.any? { |m| m.title == title }
      puts "⚠️ Movie already in the watchlist."
      return
    end

    movie = Movie.new(title, genre, status, rating)
    @movies << movie
    Storage.save_movies(@filename, @movies)
    puts "✅ Movie added to the watchlist."
  end

  def update_movie(title, rating, status, genre)
    movie = @movies.find { |m| m.title == title }
    unless movie
      puts "⚠️ Movie not found in the watchlist."
      return
    end

    unless ["to_watch", "watching", "watched"].include?(status)
      puts "❌ Invalid status. Must be 'to_watch', 'watching', or 'watched'."
      return
    end

    unless genre.is_a?(String) && ["Action", "Comedy", "Romance"].include?(genre) && !genre.match(/[^a-zA-Z\s]/)
      puts "❌ Invalid genre. Must be one of Action, Comedy, or Romance — only letters and spaces."
      return
    end

    if !rating.is_a?(Integer) || rating < 1 || rating > 5
      puts "❌ Invalid rating. Must be an integer between 1 and 5."
      return
    end

    movie.rating = rating
    movie.status = status
    movie.genre = genre
    Storage.save_movies(@filename, @movies)
    puts "🔄 Movie updated!"
  end

  def delete_movie(title)
    if !title.is_a?(String) || title.strip.empty? || title.length > 20 || title.match(/[^a-zA-Z\s]/)
      puts "❌ Invalid title. Must be a string, 1–20 characters, only letters and spaces."
      return
    end

    movie = @movies.find { |m| m.title == title }
    if movie
      @movies.delete(movie)
      Storage.save_movies(@filename, @movies)
      puts "🗑️ Movie deleted from the watchlist."
    else
      puts "⚠️ Movie not found."
    end
  end

  def display_movies(genre = nil)
    valid_genres = ["Action", "Comedy", "Romance"]
    to_display = @movies

    if genre && valid_genres.include?(genre)
      to_display = @movies.select { |m| m.genre == genre }
    elsif genre
      puts "⚠️ Invalid genre. Allowed: #{valid_genres.join(', ')}"
      return
    end

    if to_display.empty?
      puts "📭 No movies to display."
    else
      to_display.each do |movie|
        puts "#{movie.title} - #{movie.genre} - #{movie.status} - #{movie.rating || 'No rating'}"
      end
    end
  end
end
