
class Movie
  attr_accessor :title, :genre, :status, :rating

  def initialize(title, genre, status, rating = nil)
    @title = title
    @genre = genre
    @status = status  # "to_watch", "watching", "watched"
    @rating = rating
  end
end
