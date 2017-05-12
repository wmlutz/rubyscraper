require 'rubygems'
require 'mechanize'
require 'Pry' # for debugging
require 'csv' # or saving in CSV if thats what we want

a = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}

page = a.get('https://www.crunchbase.com/funding-rounds')
resultsarray = [] 										# array to hold the results

# Get the information we need from the page
puts "before loop"
page.search('.info-block .title_date').map do |c|					# block that holds the company name
	funddate = ""
	dataholder = c.text.strip
	puts dataholder

	if dataholder.include? Date.today.year.to_s
		funddate = datholder
	else
		name = c.search('.name').text.strip			# the company name itself
		fundamt = c.search('.funding_amount').text.strip		# funding amount
		# fundamt = fundamt[0,fundamt.length-2]
		fundround = c.search('.funding-type').text.strip # funding round
		fundclean = fundamt[0,(fundamt.length-2)]

		puts name
		puts fundclean
		puts fundround
		puts funddate
		puts "--------"

		unless resultsarray.include? [name, fundclean, fundround, funddate]	# checks if the entry is already in array
			resultsarray << [name, fundclean, fundround, funddate]
		end
	end
end
puts "end of loop"

# Save the data to a CSV
# File.open('test_co_name.csv','w') do |f|
# 	resultsarray.each do |l|
# 		f << l.to_csv
# 	end
# end

# gem for console debugging
# Pry.start(binding)
