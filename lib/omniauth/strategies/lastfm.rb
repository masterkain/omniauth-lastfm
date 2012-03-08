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
        :site           => "http://www.last.fm"
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
        token = request.params["token"]
        params = { :api_key => options.api_key }
        params[:token] = token
        params[:api_sig] = signature(token)
        params[:method] = "auth.getSession"
        params[:format] = "json"
        response = RestClient.get("http://ws.audioscrobbler.com/2.0/", { :params => params })
        @json = MultiJson.decode(response.to_s)
        super
      end

      uid { raw_info["name"] }

      info do
        { :name => raw_info["name"] }
      end

      extra do
        { :raw_info => raw_info }
      end

      credentials do
        { :token => raw_info["key"] }
      end

      def raw_info
        @raw_info ||= @json["session"]
      rescue ::RestClient::Exception
        raise ::Timeout::Error
      end

      protected
      def signature(token)
        sign = "api_key#{options.api_key}methodauth.getSessiontoken#{token}#{options.secret_key}"
        Digest::MD5.hexdigest(sign)
      end
    end
  end
end
