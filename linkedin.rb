require 'httpclient'
require 'nokogiri'


client = HTTPClient.new

client.set_auth("https://www.linkedin.com","username","password")

doc = Nokogiri::HTML(client.get_client("https://www.linkedin.com"))

puts doc


#require 'Pry'
#require 'csv'
 

 
#a = Mechanize.new
 
#a = Mechanize.new do |agent|
 # agent.user_agent_alias = (Mechanize::AGENT_ALIASES.keys - ['Mechanize']).sample
#end

#home_page= agent.get('http://www.linkedin.com')


#resultsarray = [] 										# array to hold the results

#puts "test"

#page.search('.results-container').map do |c|		# block that holds the company name
#	puts "test2"
#	name = c.search('.main-headline').text.strip	# the name itself
#	descr = c.search('.desription').text.strip		# location name, used primarily for testing
	
#	puts name
#	puts descr
	
	#unless resultsarray.include? [name, title, location]	# checks if the entry is already in array
	#	resultsarray << [name, title, location]
	#end
#end


# gem for console debugging
Pry.start(binding)

# https://www.linkedin.com/vsearch/p?orig=FCTD&rsid=2142406591474984548518&keywords=%22sales%20technology%22&trk=vsrp_people_sel&trkInfo=VSRPsearchId%3A2142406591474984540845,VSRPcmpt%3Atrans_nav&f_G=us%3A70&openFacets=N,G,CC,CE&f_CE=6