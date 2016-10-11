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

describe Message, type: :model do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:link) }
  it { should validate_presence_of(:method) }
  it { should validate_presence_of(:count) }
end