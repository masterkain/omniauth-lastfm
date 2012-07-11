require 'spec_helper'

describe OmniAuth::Strategies::Lastfm do
  subject do
    OmniAuth::Strategies::Lastfm.new({})
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
