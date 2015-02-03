require_relative '../safe_gorge'
require 'rack/test'
require 'timecop'

set :environment, :test
welcome_response = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Gather numDigits=\"1\" action=\"/in-call/get\" method=\"post\"><Say>Welcome to York Street. Deliveries, please press 5.\n        For a joke, press 1.\n        To speak to a person, press 2.\n        To check your future, press 3.\n        If you know anything else, at all. Please enter it now!</Say></Gather><Say>Sorry, I didn't get your response</Say><Redirect>https://safe-gorge-6634.herokuapp.com/in-call</Redirect></Response>"


describe 'SMS and Call Response Capabilities' do
	include Rack::Test::Methods

	before do
		Timecop.freeze(Time.gm(2014, 2, 17))
	end

	after do
		Timecop.return
	end

	def app
		Sinatra::Application
	end

	it "should load the home page and feed Pandas" do
		get '/'
		expect(last_response).to be_ok
		expect(last_response.body).to eq('Hello Pandas! Have some ban-boo.')
	end

	it "should respond plainly to no SMS" do
		get '/smsin'
		expect(last_response).to be_ok
		expect(last_response.body).to eq('No SMS.')
	end

	it "should accept Twilio SMS" do
		get "/smsin?ToCountry=CA&ToState=ON&SmsMessageSid=SM60c8870b5bd81d43f33a107c832b931f&NumMedia=0&ToCity=OTTAWA&FromZip=&SmsSid=SM60c8870b5bd81d43f33a107c832b931f&FromState=ON&SmsStatus=received&FromCity=OTTAWA&Body=Works+still+as+good+as+a+computer&FromCountry=CA&To=%2B16136996738&ToZip=&MessageSid=SM60c8870b5bd81d43f33a107c832b931f&AccountSid=AC4474fb44063b4118e729013bd9e9a5dd&From=%2B16138584587&ApiVersion=2010-04-01"
		expect(last_response).to be_ok
		expect(last_response.body).to eq('The sms arrived. Works still as good as a computer')
	end

end
