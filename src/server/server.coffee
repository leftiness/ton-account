"use strict"

express = require "express"
bodyParser = require "body-parser"
cookieParser = require "cookie-parser"
morgan = require "morgan"
request = require "request"

config = require "../config.json"
routes = require "./routes/index.js"
exceptionHandler = require "./common/ExceptionHandler.js"
proxyService = require "./common/ProxyService.js"

app = express()
port = process.env.PORT || config.port
hubApi = express.Router()

app.set "view engine", "jade"
app.set "views", "#{__dirname}/views"

app.use cookieParser(config.secret.cookie_secret)

hubApi.all "*", (req, res) ->
	req.pipe(proxyService.go req).pipe res

app.use "/hub", hubApi

app.use morgan "dev"
app.use bodyParser.json()
app.use bodyParser.urlencoded { extended: false }
app.use cookieParser(config.secret.cookie_secret)
app.use express.static __dirname

routes.forEach (rt) ->
	app[rt.verb] rt.path, rt.fn

app.all "*", (req, res) ->
	res.sendFile "index.html", { root: __dirname }

app.use exceptionHandler

app.listen (port), ->
	console.log "All systems are go! Port: #{port}"
