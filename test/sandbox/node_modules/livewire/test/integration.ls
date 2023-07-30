{
	route
	get, post, respond
	ok, not-found
	body-params, json, query, raw
} = require '../lib'
σ = require \highland
require! [http, freeport, 'karma-sinon-expect'.expect, \concat-stream, querystring]

assert-response = (addr, path, response, callback)-->
	http.get addr + path, (res)->
		res.pipe concat-stream encoding:\string, (data)->
			expect data .to.be response
			callback!
	.on \error callback

assert-response-options = (options, response, callback)-->
	http.request do
		options
		(res)->
			res.pipe concat-stream encoding:\string, (data)->
				expect data .to.be response
				callback!
	.on \error callback
	.end!

export
	before: (done)->
		r = route [
			get '/' -> σ <[hello]>
			get '/blah' -> σ <[foo]>
			get '/foo/:bar' ({params})-> σ [params.bar]
			post '/postroute' -> σ ['post route']

			-> σ ['not found']
		]

		e, @port <~ freeport
		done e if e?

		@assert-response = assert-response "http://localhost:#{@port}"

		@assert-response-options = (options, response, cb)~>
			assert-response-options do
				options import host:\localhost port:@port
				response, cb

		http.create-server (req, res)->
			r req .pipe res
		.listen @port, done

	'HTTP integration':
		'base route hits': (done)->
			@assert-response '/' 'hello' done

		'sub route hits': (done)->
			@assert-response '/blah' 'foo' done

		'param route interpolates': (done)->
			@assert-response '/foo/rsnt' 'rsnt' done

		'any other route uses fallback': (done)->
			@assert-response '/tfrub' 'not found' done

		'post route':
			'hits with post': (done)->
				@assert-response-options do
					path: '/postroute' method: \POST
					'post route' done
			'misses with get': (done)->
				@assert-response '/postroute' 'not found' done
