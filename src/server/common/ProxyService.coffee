request = require "request"

crypto = require "./CryptoService.js"
config = require "../config.json"

service =
	go: (req) ->
		tokenType = req.signedCookies?.token_type
		accessToken = req.signedCookies?.access_token
		secret = config.secret.oauth2.client_secret
		proof = crypto.hmac accessToken, secret if accessToken? and secret?
		auth = "#{tokenType} #{accessToken}" if tokenType? and accessToken?
		conf =
			method: req.method.toLowerCase()
			uri: "#{config.hub_url}/api#{req.path}"
			headers:
				"authorization": auth
				"X-TON-SECRET-PROOF": proof
			json: req.body if req.body?
		return request conf

module.exports = service
