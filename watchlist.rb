require_relative 'movie'
require_relative 'storage'
require_relative 'movie_database'

class Watchlist
  VALID_GENRES = ["action", "romance", "comedy"]
  VALID_STATUSES = ["to_watch", "watched", "watching"]

  def initialize(filename)
    @filename = filename
    @movies = Storage.load_movies(filename)
  end

  def valid_rating?(rating)
    return true if rating.nil? || rating.to_s.strip.empty?
    rating = rating.to_f
    rating >= 1 && rating <= 5
  end

  def valid_status?(status)
    VALID_STATUSES.include?(status.to_s.strip.downcase)
  end

  def valid_genre?(genre)
    VALID_GENRES.include?(genre.to_s.strip.downcase)
  end

  def add_movie(title, genre, status, rating = nil, year = nil, link = nil)
    title = title.to_s.strip
    genre = genre.to_s.strip.downcase
    status = status.to_s.strip.downcase
    rating = rating.to_f if rating && !rating.to_s.empty?

    if @movies.any? { |m| m.title.downcase == title.downcase }
      puts "❌ Movie already exists in your watchlist."
      return
    end
    unless valid_genre?(genre)
      puts "❌ Invalid genre. Allowed: #{VALID_GENRES.join(', ')}"
      return
    end

    unless valid_status?(status)
      puts "❌ Invalid status. Allowed: #{VALID_STATUSES.join(', ')}"
      return
    end

    unless valid_rating?(rating)
      puts "❌ Invalid rating. Must be between 1 and 5."
      return
    end

    movie = Movie.new(title: title, genre: genre, status: status, rating: rating, year: year, link: link)
    @movies << movie
    Storage.save_movies(@filename, @movies)
    puts "✅ Movie added to your watchlist."
  end

  def update_movie(title, rating = nil, status = nil, genre = nil)
    title = title.to_s.strip
    movie = @movies.find { |m| m.title.downcase == title.downcase }

    if movie
      if rating
        if valid_rating?(rating)
          movie.rating = rating.to_f
        else
          puts "❌ Invalid rating. Must be between 1 and 5."
          return
        end
      end

      if status
        if valid_status?(status)
          movie.status = status.downcase
        else
          puts "❌ Invalid status. Allowed: #{VALID_STATUSES.join(', ')}"
          return
        end
      end

      if genre
        if valid_genre?(genre)
          movie.genre = genre.downcase
        else
          puts "❌ Invalid genre. Allowed: #{VALID_GENRES.join(', ')}"
          return
        end
      end

      Storage.save_movies(@filename, @movies)
      puts "✅ Movie updated."
    else
      puts "❌ Movie not found in your watchlist."
    end
  end

  def delete_movie(title)
    title = title.to_s.strip
    before_count = @movies.size
    @movies.reject! { |m| m.title.downcase == title.downcase }
    if @movies.size < before_count
      Storage.save_movies(@filename, @movies)
      puts "🗑️ Movie deleted from your watchlist."
    else
      puts "❌ Movie not found in your watchlist."
    end
  end

  def find_and_generate_link(title, user)
    title = title.to_s.strip

    movie_data = MovieDatabase.search_movie(title)
    if movie_data
      links = MovieDatabase.generate_watch_link(movie_data)
      puts "🎬 Found: #{movie_data[:title]} (#{movie_data[:year]})"

      if user[:role] == "member"
        puts "📺 Watch links (one should work):"
        links.each_with_index do |link, index|
          puts "  #{index + 1}. #{link}"
        end
        return { link: links.first, year: movie_data[:year] }
      else
        puts "🔒 Only members can view watch links."
        return { link: nil, year: movie_data[:year] }
      end
    else
      puts "⚠️ Movie not found in database. Available movies:"
      puts MovieDatabase.list_available_movies.first(10).join(", ")
      puts "... and more"
      return { link: nil, year: nil }
    end
  end

  def display_movies(genre = nil, user = nil)
    to_display = @movies

    if genre
      normalized_genre = genre.to_s.downcase
      unless VALID_GENRES.include?(normalized_genre)
        puts "⚠️ Invalid genre. Allowed: #{VALID_GENRES.map(&:capitalize).join(', ')}"
        return
      end
      to_display = @movies.select { |m| m.genre.to_s.downcase == normalized_genre }
    end

    if to_display.empty?
      puts "📭 No movies to display."
    else
      to_display.each do |movie|
        year = movie.year || MovieDatabase.search_movie(movie.title)&.dig(:year)
        puts "🎬 #{movie.title} (#{year}) - #{movie.status.capitalize} - #{movie.rating}⭐ - Genre: #{movie.genre.capitalize}"

        if movie.link && user&.dig(:role) == "member"
          puts "🎬 Watch now: #{movie.link}"
        end
      end

      puts "🔒 Only members can view watch links." if user&.dig(:role) != "member"
    end
  end
end