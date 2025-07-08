# watchlist.rb
require_relative 'movie'
require_relative 'storage'

class Watchlist
  def initialize(filename)
    @filename = filename
    @movies = Storage.load_movies(filename)
  end
  
  def generate_watch_link(title, year)
    slug = title.downcase.gsub(/[^a-z0-9\s]/, '').strip.gsub(/\s+/, '-')
    "https://www.lookmovie2.to/movies/view/#{slug}-#{year}"
  end

  def add_movie(title, genre, status, rating = nil, year = nil, link = nil)
    if !title.is_a?(String) || title.strip.empty? || title.length > 20 || title.match(/[^a-zA-Z\s]+/)
      puts "❌ Invalid title. Must be a string, 1–20 characters, only letters and spaces."
      return
    end

    unless ["Action", "Comedy", "Romance","action","comedy","romance"].include?(genre)
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

    movie = Movie.new(title: title, genre: genre, status: status, rating: rating, year: year, link: link)
    @movies << movie
    Storage.save_movies(@filename, @movies)
    puts "Movie #{title} , genre #{genre} , status #{status} , rating #{rating} added to the watchlist!"
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
    valid_genres = ["action", "comedy", "romance"]
    to_display = @movies

    if genre
      normalized_genre = genre.downcase
      if valid_genres.include?(normalized_genre)
        to_display = @movies.select { |m| m.genre.to_s.downcase == normalized_genre }
      else
        puts "⚠️ Invalid genre. Allowed: #{valid_genres.map(&:capitalize).join(', ')}"
        return
      end
    end

    if to_display.empty?
      puts "📭 No movies to display."
    else
      to_display.each do |movie|
        puts "#{movie.title} - #{movie.genre} - #{movie.status} - #{movie.rating || 'No rating'} - #{movie.year}"
        puts "🎬 Watch now: #{movie.link}" if movie.link

      end
    end
  end
end
