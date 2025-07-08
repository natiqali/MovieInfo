
# movie_database.rb
class MovieDatabase
  MOVIES = {
    "batman" => { year: 2022, title: "The Batman" },
    "the batman" => { year: 2022, title: "The Batman" },
    "batman begins" => { year: 2005, title: "Batman Begins" },
    "the dark knight" => { year: 2008, title: "The Dark Knight" },
    "inception" => { year: 2010, title: "Inception" },
    "interstellar" => { year: 2014, title: "Interstellar" },
    "the matrix" => { year: 1999, title: "The Matrix" },
    "titanic" => { year: 1997, title: "Titanic" },
    "avatar" => { year: 2009, title: "Avatar" },
    "avengers" => { year: 2012, title: "The Avengers" },
    "endgame" => { year: 2019, title: "Avengers: Endgame" },
    "infinity war" => { year: 2018, title: "Avengers: Infinity War" },
    "iron man" => { year: 2008, title: "Iron Man" },
    "spider man" => { year: 2002, title: "Spider-Man" },
    "joker" => { year: 2019, title: "Joker" },
    "deadpool" => { year: 2016, title: "Deadpool" },
    "wonder woman" => { year: 2017, title: "Wonder Woman" },
    "aquaman" => { year: 2018, title: "Aquaman" },
    "fast furious" => { year: 2001, title: "The Fast and the Furious" },
    "john wick" => { year: 2014, title: "John Wick" },
    "die hard" => { year: 1988, title: "Die Hard" },
    "terminator" => { year: 1984, title: "The Terminator" },
    "alien" => { year: 1979, title: "Alien" },
    "predator" => { year: 1987, title: "Predator" },
    "gladiator" => { year: 2000, title: "Gladiator" },
    "la la land" => { year: 2016, title: "La La Land" },
    "casablanca" => { year: 1942, title: "Casablanca" },
    "forrest gump" => { year: 1994, title: "Forrest Gump" },
    "pulp fiction" => { year: 1994, title: "Pulp Fiction" },
    "goodfellas" => { year: 1990, title: "Goodfellas" },
    "the godfather" => { year: 1972, title: "The Godfather" },
    "scarface" => { year: 1983, title: "Scarface" },
    "shrek" => { year: 2001, title: "Shrek" },
    "toy story" => { year: 1995, title: "Toy Story" },
    "finding nemo" => { year: 2003, title: "Finding Nemo" },
    "frozen" => { year: 2013, title: "Frozen" },
    "the hangover" => { year: 2009, title: "The Hangover" },
    "superbad" => { year: 2007, title: "Superbad" },
    "step brothers" => { year: 2008, title: "Step Brothers" },
    "anchorman" => { year: 2004, title: "Anchorman" },
    "dumb and dumber" => { year: 1994, title: "Dumb and Dumber" },
    "notting hill" => { year: 1999, title: "Notting Hill" },
    "amelie" => { year: 2001, title: "Amélie" },
    "edge of tomorrow" => { year: 2014, title: "Edge of Tomorrow" }
  }.freeze

  def self.search_movie(query)
    normalized_query = query.downcase.strip
    
    # Direct match
    return MOVIES[normalized_query] if MOVIES[normalized_query]
    
    # Partial match
    MOVIES.each do |key, value|
      if key.include?(normalized_query) || normalized_query.include?(key)
        return value
      end
    end
    
    nil
  end

  def self.generate_watch_link(movie_data)
    return nil unless movie_data
    
    title = movie_data[:title]
    year = movie_data[:year]
    slug = title.downcase
                .gsub(/[^a-z0-9\s]/, '')
                .strip
                .gsub(/\s+/, '-')
    
    "https://www.lookmovie2.to/movies/view/#{slug}-#{year}"
  end

  def self.list_available_movies
    MOVIES.values.map { |movie| "#{movie[:title]} (#{movie[:year]})" }.sort
  end
end
