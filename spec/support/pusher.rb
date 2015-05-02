RSpec.configure do |config|

  config.before(:each) do
    allow(Pusher).to receive(:trigger).and_return({})
  end
end