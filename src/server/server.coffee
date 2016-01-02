"use strict"

express = require "express"
bodyParser = require "body-parser"
cookieParser = require "cookie-parser"
morgan = require "morgan"

config = require "../config.json"
routes = require "./routes/index.js"
exceptionHandler = require "./common/ExceptionHandler.js"
tokenInterceptor = require "./common/TokenInterceptor.js"

app = express()
port = process.env.PORT || config.port

app.set "view engine", "jade"
app.set "views", "#{__dirname}/views"

app.use morgan "dev"
app.use bodyParser.json()
app.use bodyParser.urlencoded { extended: false }
app.use cookieParser(config.secret.cookie_secret)
app.use express.static __dirname
app.use tokenInterceptor

routes.forEach (rt) ->
	app[rt.verb] "/api#{rt.path}", rt.fn

app.all "/api/*", (req, res) ->
	# TODO req.body.proof = getAppSecretProof()
	res.redirect "#{config.hub_url}#{req.originalUrl}"

app.all "*", (req, res) ->
	res.sendFile "index.html", { root: __dirname }

app.use exceptionHandler

app.listen (port), ->
	console.log "All systems are go! Port: #{port}"
