
# movie_database.rb
class MovieDatabase
  MOVIES = {
    "batman" => { year: 2022, title: "The Batman", imdb_id: "tt1877830" },
    "the batman" => { year: 2022, title: "The Batman", imdb_id: "tt1877830" },
    "batman begins" => { year: 2005, title: "Batman Begins", imdb_id: "tt0372784" },
    "the dark knight" => { year: 2008, title: "The Dark Knight", imdb_id: "tt0468569" },
    "inception" => { year: 2010, title: "Inception", imdb_id: "tt1375666" },
    "interstellar" => { year: 2014, title: "Interstellar", imdb_id: "tt0816692" },
    "the matrix" => { year: 1999, title: "The Matrix", imdb_id: "tt0133093" },
    "titanic" => { year: 1997, title: "Titanic", imdb_id: "tt0120338" },
    "avatar" => { year: 2009, title: "Avatar", imdb_id: "tt0499549" },
    "avengers" => { year: 2012, title: "The Avengers", imdb_id: "tt0848228" },
    "endgame" => { year: 2019, title: "Avengers: Endgame", imdb_id: "tt4154796" },
    "infinity war" => { year: 2018, title: "Avengers: Infinity War", imdb_id: "tt4154756" },
    "iron man" => { year: 2008, title: "Iron Man", imdb_id: "tt0371746" },
    "spider man" => { year: 2002, title: "Spider-Man", imdb_id: "tt0145487" },
    "joker" => { year: 2019, title: "Joker", imdb_id: "tt7286456" },
    "deadpool" => { year: 2016, title: "Deadpool", imdb_id: "tt1431045" },
    "wonder woman" => { year: 2017, title: "Wonder Woman", imdb_id: "tt0451279" },
    "aquaman" => { year: 2018, title: "Aquaman", imdb_id: "tt1477834" },
    "fast furious" => { year: 2001, title: "The Fast and the Furious", imdb_id: "tt0232500" },
    "john wick" => { year: 2014, title: "John Wick", imdb_id: "tt3039222" },
    "die hard" => { year: 1988, title: "Die Hard", imdb_id: "tt0095016" },
    "terminator" => { year: 1984, title: "The Terminator", imdb_id: "tt0088247" },
    "alien" => { year: 1979, title: "Alien", imdb_id: "tt0078748" },
    "predator" => { year: 1987, title: "Predator", imdb_id: "tt0093773" },
    "gladiator" => { year: 2000, title: "Gladiator", imdb_id: "tt0172495" },
    "la la land" => { year: 2016, title: "La La Land", imdb_id: "tt3783958" },
    "casablanca" => { year: 1942, title: "Casablanca", imdb_id: "tt0034583" },
    "forrest gump" => { year: 1994, title: "Forrest Gump", imdb_id: "tt0109830" },
    "pulp fiction" => { year: 1994, title: "Pulp Fiction", imdb_id: "tt0110912" },
    "goodfellas" => { year: 1990, title: "Goodfellas", imdb_id: "tt0099685" },
    "the godfather" => { year: 1972, title: "The Godfather", imdb_id: "tt0068646" },
    "scarface" => { year: 1983, title: "Scarface", imdb_id: "tt0086250" },
    "shrek" => { year: 2001, title: "Shrek", imdb_id: "tt0126029" },
    "toy story" => { year: 1995, title: "Toy Story", imdb_id: "tt0114709" },
    "finding nemo" => { year: 2003, title: "Finding Nemo", imdb_id: "tt0266543" },
    "frozen" => { year: 2013, title: "Frozen", imdb_id: "tt2294629" },
    "the hangover" => { year: 2009, title: "The Hangover", imdb_id: "tt1119646" },
    "superbad" => { year: 2007, title: "Superbad", imdb_id: "tt0829482" },
    "step brothers" => { year: 2008, title: "Step Brothers", imdb_id: "tt0838283" },
    "anchorman" => { year: 2004, title: "Anchorman", imdb_id: "tt0357413" },
    "dumb and dumber" => { year: 1994, title: "Dumb and Dumber", imdb_id: "tt0109686" },
    "notting hill" => { year: 1999, title: "Notting Hill", imdb_id: "tt0125439" },
    "amelie" => { year: 2001, title: "Amélie", imdb_id: "tt0211915" },
    "edge of tomorrow" => { year: 2014, title: "Edge of Tomorrow", imdb_id: "tt1631867" }
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
    imdb_id = movie_data[:imdb_id]
    
    slug = title.downcase
                .gsub(/[^a-z0-9\s]/, '')
                .strip
                .gsub(/\s+/, '-')
    
    # Generate exactly 2 URL formats
    links = []
    
    if imdb_id
      # IMDb ID format (without 'tt' prefix)
      imdb_number = imdb_id.gsub(/^tt/, '')
      links << "https://www.lookmovie2.to/movies/view/#{imdb_number}-#{slug}-#{year}"
    end
    
    # Title-year format (always included as fallback)
    links << "https://www.lookmovie2.to/movies/view/#{slug}-#{year}"
    
    # Remove duplicates and return exactly 2 links
    links.uniq
  end

  def self.list_available_movies
    MOVIES.values.map { |movie| "#{movie[:title]} (#{movie[:year]})" }.sort
  end
end
