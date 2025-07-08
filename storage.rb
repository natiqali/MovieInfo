# storage.rb
require 'csv'
require_relative 'movie'

class Storage
  def self.load_movies(filename)
    return [] unless File.exist?(filename)

    CSV.read(filename, headers: true).map do |row|
      Movie.new(
        title: row["title"],
        genre: row["genre"],
        status: row["status"],
        rating: row["rating"]&.to_i,
        year: row["year"]&.to_i,
        link: row["link"]
      )
    end
  end

  def self.save_movies(filename, movies)
    CSV.open(filename, "w", write_headers: true, headers: ["title", "genre", "status", "rating","year","link"]) do |csv|
      movies.each do |movie|
        csv << [movie.title, movie.genre, movie.status, movie.rating, movie.year, movie.link]
      end
    end
  end
end
