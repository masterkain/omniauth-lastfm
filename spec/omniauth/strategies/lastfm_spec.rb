require 'spec_helper'

describe OmniAuth::Strategies::Lastfm do
  subject do
    OmniAuth::Strategies::Lastfm.new({})
  end

  context 'setting callback url in devise.rb' do
    let(:url) { 'https://localhost:1337/auth/lastfm/callback' }
    let(:client) { OmniAuth::Strategies::Lastfm.new(:lastfm, client_options: { callback: url})}

    it 'should use the callback url' do
      client.should_receive(:redirect)
        .with("http://www.last.fm/api/auth/?&cb=https://localhost:1337/auth/lastfm/callback")
      client.request_phase
    end
  end

  context 'client options' do
    it 'should have the correct name' do
      subject.options.name.should eq('lastfm')
    end

    it 'should have correct site' do
      subject.options.client_options.site.should eq('http://www.last.fm')
    end

    it 'should have correct api url' do
      subject.options.client_options.api_url.should eq('http://ws.audioscrobbler.com/2.0/')
    end

    it 'should have correct authorize path' do
      subject.options.client_options.authorize_path.should eq('/api/auth')
    end
  end

end
