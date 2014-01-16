require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

get '/' do
  html = %q(
  <html><head><title>Movie Search</title></head><body>
  <h1>Find a Movie!</h1>
  <form accept-charset="UTF-8" action="/result" method="post">
    <label for="movie">Search for:</label>
    <input id="movie" name="movie" type="text" />
    <input name="commit" type="submit" value="Search" /> 
  </form></body></html>
  )
end

post '/result' do
  search_str = params[:movie]

  # Make a request to the omdb api here!
  search = Typhoeus.get("www.omdbapi.com", :params => {:s => "#{search_str}"})
  grab_hashes = JSON.parse(search.body)
  temp = grab_hashes["Search"].map { |ele| "#{ele["Title"]}"}
  # temp1 = temp.map { |ele| "#{ele["Title"]}"}


  # grab_files = JSON.parse(search.body).to_s
  # organize = grab_files.each {|grab| grab["Title"]}
  # grab_files = organize

  # Modify the html output so that a list of movies is provided.
  html_str = "<html><head><title>Movie Search Results</title></head><body><h1>Movie Results</h1>\n<ul>"
  html_str += "<li>#{search.body}</li></ul></body></html>"
  # html_str += "<li> grab_hashes["Search"].each { |ele| "#{ele['Title']}"} </li>"



organize = search.body { |grab| puts grab["Search"]}
  



end

get '/poster/:imdb' do |imdb_id|
  # Make another api call here to get the url of the poster.
  html_str = "<html><head><title>Movie Poster</title></head><body><h1>Movie Poster</h1>\n"
  html_str = "<h3>#{imdb_id}</h3>"
  html_str += '<br /><a href="/">New Search</a></body></html>'

end

