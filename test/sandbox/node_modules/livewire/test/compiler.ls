require! {
	'karma-sinon-expect'.expect
	'../lib/compiler'.compile-path
	σ: highland
}

Stream = σ!constructor

export
	"compiler should be a curried function": ->
		expect (compile-path '/') .to.be.a Function
	"compiler should return a Stream": ->
		expect ((compile-path '/') '/') .to.be.a Stream
	"compiler should return nonempty Stream on matching path": (done)->
		((compile-path '/') '/').to-array (xs)->
			expect xs .not.to.be.empty!
			done!

	"compiler should return empty Stream on nonmatching path": (done)->
		((compile-path '/') '/nope').to-array (xs)->
			expect xs .to.be.empty!
			done!

	"the stream contains params": (done)->
		((compile-path '/:param') '/value').to-array (xs)->
			expect xs .to.eql [param:'value']
			done!

	"supports multiple params": (done)->
		((compile-path '/:param/:param2') '/value/foo').to-array (xs)->
			expect xs .to.eql [param:'value' param2:'foo']
			done!

	"trailing slash matches":  (done)->
		((compile-path '/trail/') '/trail').to-array (xs)->
			expect xs .not.to.be.empty!
			done!

	"trailing slash implies prefix": (done)->
		((compile-path '/trail/') '/trail/path').to-array (xs)->
			expect xs .not.to.be.empty!
			done!

	"path trailing slash doesn't matter":  (done)->
		((compile-path '/path') '/path/').to-array (xs)->
			expect xs .not.to.be.empty!
			done!

	"path trailing slash doesn't matter (trailing slash)":  (done)->
		((compile-path '/path/') '/path/').to-array (xs)->
			expect xs .not.to.be.empty!
			done!

