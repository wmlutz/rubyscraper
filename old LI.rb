require 'mechanize'
require 'Pry'
require 'csv'
 
a = Mechanize.new
 
a = Mechanize.new do |agent|
  agent.user_agent_alias = (Mechanize::AGENT_ALIASES.keys - ['Mechanize']).sample
end

parentpage = a.get('https://www.linkedin.com/jobs/search?keywords=Salesforce+Developer&locationId=us%3A0&f_GC=us%2E3-2-0-31-1&trk=jobs_jserp_facet_geo_city')
resultsarray = [] 										# array to hold the results
another_page = true
page_num = 0
childpage = ""

parentpage.search('.job-details').map do |jobgroup|
	name = jobgroup.search('.company-name-text').text.strip
	job_url = jobgroup.search('.job-title-link').first.attr('href')
	childpage = a.get(job_url)
	
	puts name
	#puts childpage
	
	personname = childpage.search('.info-container-upsell')
	
	puts personname
	# THIS DOESN'T WORK DON'T KNOW WHY YET
	#childpage.css('div.info-container-upsell').map do |c|
	#	puts c.search('h4').text.strip
	#end
	
	#puts childpage.map.search('div.info-container-upsell h4').text.strip
	# HAVE URL, JUST NEED TO ITERATE INTO THAT PAGE TO FIND NAME OF HIRING MANAGER
	
	#resultsarray << [name]
end

# Also need to loop for multiple pages.


# gem for console debugging
#Pry.start(binding)