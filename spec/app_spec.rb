ENV['RACK_ENV'] = 'test'

require './app.rb'
require 'rspec'
require 'rack/test'
require 'shoulda/matchers'

RSpec.configure do |config|
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
  end
end

describe 'The MessageVanishes appication' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "display Enter Message form" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Enter your message')
  end

  it "can create the message" do
    post '/', "message[count]"=>1, "message[method]"=>"visits", "message[body]"=>"U2FsdGVkX1+FuqdXOIS864o1ncw5m3ut7p+wU7LpoQQ=", "password"=>"123456"
    expect(last_response).to be_ok
    expect(last_response.body).to include('Message already added')
  end

  it "show the mesage if the password too small" do
    post '/', "message[count]"=>1, "message[method]"=>"visits", "message[body]"=>"U2FsdGVkX1+FuqdXOIS864o1ncw5m3ut7p+wU7LpoQQ=", "password"=>"12345"
    expect(last_response).to be_ok
    expect(last_response.body).to include('Password too small (min. 6 symbols)!')
  end

  it "show info if the message is not found" do
    get '/message/aaaaaaaaaaaaaaa'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Message not found')
  end

  it "show the message dialog if the message is found" do
    m=Message.new(:body=>"U2FsdGVkX1+FuqdXOIS864o1ncw5m3ut7p+wU7LpoQQ=")
    m.save!
    get "/message/#{m.link}"
    expect(last_response).to be_ok
    expect(last_response.body).to include('Show message')
    Message.delete_all
  end

  it "can destroy message after a certain number of visits" do
    m=Message.new(:body=>"U2FsdGVkX1+FuqdXOIS864o1ncw5m3ut7p+wU7LpoQQ=", :count=>5, :method=>"visits")
    m.save!
    5.times { get "/message/#{m.link}" }
    get "/message/#{m.link}"
    expect(last_response).to be_ok
    expect(last_response.body).to include('Message destroyed.')
    Message.delete_all
  end

end

describe Message, type: :model do
  describe "validation" do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:link) }
    it { should validate_presence_of(:method) }
    it { should validate_presence_of(:count) }
    it { should validate_numericality_of(:count).is_less_than(10000).with_message("in field \"Destroy after\" is too big (max. 9999)") }
    it { should validate_numericality_of(:count).is_greater_than_or_equal_to(0).with_message("in field \"Destroy after\" is too small (min. 0)") }
  end

  it "can create the new message with default values" do
    m=Message.new
    expect(m.count).to eq 1
    expect(m.method).to eq "hours"
    expect(m.link.size).to eq 15
  end
end