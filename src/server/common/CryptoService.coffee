crypto = require "crypto-js"

service =
	hmac: (accessToken, secret) ->
		obj = crypto.HmacSHA256 accessToken, secret
		return obj.toString()

module.exports = service
