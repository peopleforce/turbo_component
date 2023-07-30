{
	route
	get, post, respond
	ok, not-found
	body-params
} = require './lib'
σ = require \highland
require! http

r = route [
	get '/' -> σ <[hello]>
	get '/blah' -> σ <[foo]>
	get '/foo/:bar' ({params})-> σ [params.bar]
	-> σ ['not found']
]

http.create-server (req, res)->
	r req .pipe res
.listen 8000
