require! {
	'karma-sinon-expect'.expect
	'../lib/route'.route
	σ: highland
}

export
	"Route":
		"responds with empty stream when empty list": (done)->
			r = route []
			r!.to-array (xs)->
				expect xs .to.be.empty!
				done!

		"responds with a function that doesn't return empty stream": (done)->
			r = route [
				-> σ <[hello]>
			]

			r!.to-array (xs)->
				expect xs .to.be.eql <[hello]>
				done!

		"skips past functions that return nil": (done)->
			r = route [
				-> σ []
				-> σ []
				-> σ <[hello]>
			]

			r!.to-array (xs)->
				expect xs .to.be.eql <[hello]>
				done!

		"returns first nonempty stream": (done)->
			r = route [
				-> σ []
				-> σ <[hello]>
				-> σ <[world]>
			]

			r!.to-array (xs)->
				expect xs .to.be.eql <[hello]>
				done!


