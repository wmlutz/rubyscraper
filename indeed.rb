require 'mechanize'
require 'Pry'
require 'csv'

a = Mechanize.new
page = a.get('https://www.indeed.com/jobs?as_and=&as_phr=&as_any=Salesforce&as_not=&as_ttl=&as_cmp=-%22Mason+Frank%22+-Salesforce+-Deloitte+-%22PricewaterhouseCoopers+LLC%22&jt=all&st=&sr=directhire&salary=&radius=50&l=10011&fromage=1&limit=50&sort=date&psf=advsrch')
resultsarray = [] 										# array to hold the results

# Get the information we need from the page
page.search('.result').map do |c|					# block that holds the company name
	name = c.search('.company').text.strip			# the company name itself
	title = c.search('.jobtitle').text.strip		# job title

	puts name
	puts title

	unless resultsarray.include? [name, title]	# checks if the entry is already in array
		resultsarray << [name, title]
	end
end

# Save the data to a CSV
File.open('test_co_name.csv','w') do |f|
	resultsarray.each do |l|
		f << l.to_csv
	end
end

# gem for console debugging
# Pry.start(binding)
