require 'capybara'
require 'capybara/poltergeist'

session = Capybara::Session.new(:poltergeist)
session.visit('https://www.linkedin.com/jobs/view/134250882')

all(".info-container-upsell").each do |post|
	name = post.find("h4").text
	puts name
end