require 'mechanize'
require 'Pry'
require 'csv'

a = Mechanize.new
page = a.get('http://www.indeed.com/jobs?q=Salesforce+Developer&l=New+York%2C+NY&sort=date&fromage=15&radius=25')
resultsarray = [] # array to hold the results
another_page = true
page_num = 0

while another_page

	# Get the information we need from the page
	page.search('.result').map do |c|					# block that holds the company name
		name = c.search('.company').text.strip			# the company name itself
		location = c.search('.location').text.strip		# location name, used primarily for testing

		unless resultsarray.include? [name, location]	# checks if the entry is already in array
			resultsarray << [name, location]
		end
	end
	
	# checks if there is another page - defaults to stop the loop 
	another_page = false
	
	page.search('div.pagination span.np').map do |e| 	# searches the page for the pagination div, and the span for np - next page
		if e.text[0,4] == 'Next'						# sets another_page to true iff it finds a 'next' page, otherwise stays false
			another_page = true
		end
	end
	
	# gets the next page iff there is another page
	if another_page
		page = a.get("http://www.indeed.com/jobs?q=Salesforce+Developer&l=New+York%2C+NY&sort=date&fromage=15&radius=25&start=" + (page_num +10).to_s)
	end
	
	page_num += 10										# iterates on the page num counter
	
end

# Save the data to a CSV
File.open('test_co_name.csv','w') do |f| 
	resultsarray.each do |l|
		f << l.to_csv
	end
end

# gem for console debugging
# Pry.start(binding)
