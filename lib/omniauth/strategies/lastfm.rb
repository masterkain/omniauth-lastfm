require "multi_json"
require "oauth"
require "omniauth"
require "rest-client"

module OmniAuth
  module Strategies
    class Lastfm
      include OmniAuth::Strategy

      args [:api_key, :secret_key]
      option :api_key, nil
      option :secret_key, nil
      option :name, "lastfm"
      option :client_options, {
        :authorize_path => "/api/auth",
        :site           => "http://www.last.fm",
        :api_url        => "http://ws.audioscrobbler.com/2.0/",
      }

      attr_reader :json

      def request_phase
        params = {
          :api_key => options.api_key,
          :cb      => options.client_options["callback"]
        }
        query_string = params.map{ |key,value| "#{key}=#{Rack::Utils.escape(value)}" }.join("&")
        redirect "#{options.client_options.site}#{options.client_options.authorize_path}/?#{query_string}"
      end

      def callback_phase
        @json = {}
        token = request.params["token"]
        begin
          params = { :api_key => options.api_key,
                     :token   => token,
                     :api_sig =>  signature(token),
                     :method  => "auth.getSession",
                     :format  => 'json'}
          response = RestClient.get(options.client_options.api_url, { :params => params })
          session = MultiJson.decode(response.to_s)
          @json.merge!(session)

          params = {:api_key  => options.api_key,
                    :user     => @json['session']['name'],
                    :method   => 'user.getInfo',
                    :format   => 'json'}
          response = RestClient.get(options.client_options.api_url, { :params => params })
          user = MultiJson.decode(response.to_s)
          @json.merge!(user)
        rescue ::RestClient::Exception
          raise ::Timeout::Error
        end
        super
      end

      uid do
        @json['session']['name']
      end

      info do
        {
          :nickname =>  @json['user']['name'],
          :name     =>  @json['user']['realname'],
          :url      =>  @json['user']['url'],
          :image    =>  @json['user']['image'].instance_of?(Array) ? @json['user']['image'].last['#text'] :  @json['user']['image'],
          :country  =>  @json['user']['country'],
          :age      =>  @json['user']['age'],
          :gender   =>  @json['user']['gender'],
        }
      end

      extra do
        { :raw_info => @json['user'] }
      end

      credentials do
        {
          :token => @json['session']['key'],
          :name  => @json['session']['name'],
        }
      end

      protected

      def signature(token)
        sign = "api_key#{options.api_key}methodauth.getSessiontoken#{token}#{options.secret_key}"
        Digest::MD5.hexdigest(sign)
      end
    end
  end
end
