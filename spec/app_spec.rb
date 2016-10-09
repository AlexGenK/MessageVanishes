ENV['RACK_ENV'] = 'test'

require './app.rb'
require 'rspec'
require 'rack/test'

describe 'The MessageVanishes App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "display Enter Message form" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Enter your message')
  end
end