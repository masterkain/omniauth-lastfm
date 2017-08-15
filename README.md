OmniAuth Last.fm
================

Last.fm strategy for OmniAuth 1.0. 

Installing
----------
Add to your Gemfile:

	gem 'omniauth'
	gem 'omniauth-lastfm'

Then `bundle install`.

Usage
-----
You'll need an API account with Last.fm, you can get one here - http://www.last.fm/api. 

Usage of the gem is very similar to other OmniAuth 1.0 strategies. You'll need to add your API keys to `config/initializers/omniauth.rb`:
```ruby
	Rails.application.config.middleware.use OmniAuth::Builder do
	  provider :lastfm, "consumer_key", "consumer_secret"
	end
```
Now simply follow the README at: https://github.com/intridea/omniauth.

*Note: When setting the callback url,* please note that last.fm does not give an option for multiple urls and this field cannot be edited after account creation. To override this url, (for example, in development mode) you may pass a `callback` parameter inside the `client_options` hash:
```ruby
provider :lastfm, "consumer_key", "consumer_secret", client_options: { callback: 'http://localhost:3000/path/to/auth/callback'}
```

Auth Hash Schema
----------------
Here's an example auth hash, available in `request.env['omniauth.auth']`:

	{
	   "provider": "lastfm",
	   "uid": "ripuk",
	   "info": {
	      "nickname": "ripuk",
	      "name": "David Stephens",
	      "url": "http://www.last.fm/user/ripuk",
	      "image": "http://userserve-ak.last.fm/serve/252/46787679.jpg",
	      "country": "UK",
	      "age": "31",
	      "gender": "m"
	   },
	   "credentials": {
	      "token": "abcdefghijklmnop",
	      "name": "ripuk"
	   },
	   "extra": {
	      "raw_info": {
	         "name": "ripuk",
	         "realname": "David Stephens",
	         "image": [
	            {
	               "#text": "http://userserve-ak.last.fm/serve/34/46787679.jpg",
	               "size": "small"
	            },
	            {
	               "#text": "http://userserve-ak.last.fm/serve/64/46787679.jpg",
	               "size": "medium"
	            },
	            {
	               "#text": "http://userserve-ak.last.fm/serve/126/46787679.jpg",
	               "size": "large"
	            },
	            {
	               "#text": "http://userserve-ak.last.fm/serve/252/46787679.jpg",
	               "size": "extralarge"
	            }
	         ],
	         "url": "http://www.last.fm/user/ripuk",
	         "id": "25400308",
	         "country": "UK",
	         "age": "31",
	         "gender": "m",
	         "subscriber": "0",
	         "playcount": "11530",
	         "playlists": "0",
	         "bootstrap": "0",
	         "registered": {
	            "#text": "2009-12-30 00:53",
	            "unixtime": "1262134389"
	         },
	         "type": "user"
	      }
	   }
	}
	
What Next?
----------
The [Rockstar Gem](https://github.com/putpat/rockstar) is a great way to make use of the auth token retrieved with this gem.