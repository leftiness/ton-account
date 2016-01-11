uuid = require "node-uuid"

config = require "../../../config.json"

route =
	verb: "get"
	path: "/api/login"
	fn: [
		(req, res) ->
			state = uuid.v4()
			opts =
				signed: true
				httpOnly: true
				#secure: true # TODO Requires https
			res.cookie "ton-state", state, opts
			client = config.secret.oauth2.client_id
			redirect = config.secret.oauth2.redirect_uri
			url = "#{config.hub_url}/oauth2/authorize\
				?response_type=code\
				&client_id=#{client}\
				&redirect_uri=#{redirect}\
				&scope=foo\
				&state=#{state}"
			res.redirect url
	]

module.exports = route
