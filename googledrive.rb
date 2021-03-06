require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'json'
require 'rubygems'
require 'mechanize'

require 'fileutils'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
APPLICATION_NAME = 'Google Sheets API Ruby Quickstart'
CLIENT_SECRETS_PATH = 'client_secret.json'
CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                             "sheets.googleapis.com-ruby-quickstart.yaml")
SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
def authorize
  FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

  client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(
    client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(
      base_url: OOB_URI)
    puts "Open the following URL in the browser and enter the " +
         "resulting code after authorization"
    puts url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI)
  end
  credentials
end

# Initialize the API
service = Google::Apis::SheetsV4::SheetsService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

# def to_json(options = {})
#   JSON.pretty_generate(self, options)
# end
# The spreadsheet to request.
spreadsheet_id = '1OchgafoPg22jQgh3WU2v_9Rfy3YIVPls7s135tpCh5I'

# The ranges to retrieve from the spreadsheet.
range = ['Sheet1!A1:D1']

# include_grid_data = true
# #response = service.get_spreadsheet(spreadsheet_id, ranges: ranges, include_grid_data: include_grid_data)
# json = response.to_json
# puts json


##### WRITES TO THE FILE
value_input_option = 'RAW'
# How the input data should be inserted.
insert_data_option = 'INSERT_ROWS'

def getPayload
  a = Mechanize.new { |agent|
    agent.user_agent_alias = 'Mac Safari'
  }

  page = a.get('https://www.crunchbase.com/funding-rounds')
  resultsarray = []

  # Get the information we need from the page
  puts "before loop"
  funddate = Time.now.strftime("%m/%d/%Y")
  page.search('.info-block').map do |c|					# block that holds the company name
		name = c.search('.name').text.strip			# the company name itself
		fundamt = c.search('.funding_amount').text.strip		# funding amount
		# fundamt = fundamt[0,fundamt.length-2]
		fundround = c.search('.funding-type').text.strip # funding round
		fundclean = fundamt[0,(fundamt.length-2)]

		# puts name
		# puts fundclean
		# puts fundround
		# puts funddate
		# puts "--------"

		unless resultsarray.include? [name, fundclean, fundround, funddate]	# checks if the entry is already in array
			resultsarray << [name, fundclean, fundround, funddate]
		end
  end
  puts "end of loop"

  return resultsarray
end

data = getPayload
# Assign values to desired members of `request_body`:
payload = Google::Apis::SheetsV4::ValueRange.new
payload = {
  "range": "Sheet1!A1:D1",
  "majorDimension": "ROWS",
  "values": data,
}

puts payload.to_s



## ------------------ Turn on when ready to add values
response = service.append_spreadsheet_value(spreadsheet_id, range, payload, value_input_option: value_input_option, insert_data_option: insert_data_option)
puts response.to_json
