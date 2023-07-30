require! {
	'karma-sinon-expect'.expect
	'../lib/respond'
	'../lib/compiler'
	σ: highland
}

export 'Responder':

	"should create dsl methods": ->
		expect respond
		.to.have.keys <[get post put delete patch options head trace connect]>

	'returns empty stream if method doesn\'t match': (done)->
		r = respond \GET '/' ->
		r method:\POST url:'/' .to-array (xs)->
			expect xs .to.be.empty!
			done!

	'returns empty stream if compile doesn\'t match': (done)->
		r = respond \GET '/' ->
		r method:\GET url:'/nope' .to-array (xs)->
			expect xs .to.be.empty!
			done!

	'calls responder with request, returns a Stream': (done)->
		resp = expect.sinon.stub!
		resp.returns σ <[response]>
		route = respond \GET '/' resp
		request = method:\GET url:'/'

		route request .to-array (xs)->
			expect resp .to.be.called!
			expect resp.last-call.args.0 .to.eql request
			expect resp.last-call.args.0 .to.have.property \params
			expect xs .to.eql <[response]>
			done!
