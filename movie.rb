
class Movie
  attr_accessor :title, :genre, :status, :rating, :year, :link

  def initialize(title:, genre:, status:, rating: nil, year: nil, link: nil)
    @title = title
    @genre = genre
    @status = status  # "to_watch", "watching", "watched"
    @rating = rating
    @year = year
    @link = link
  end
end
