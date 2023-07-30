include node_modules/make-livescript/livescript.mk

.PHONY: test cover watch
test: cover $(wildcard test/*.ls)
	node_modules/.bin/istanbul report text
	node_modules/.bin/istanbul check-coverage --statements -1 --branches -1 --functions -1

cover: all
	node_modules/.bin/istanbul cover node_modules/.bin/_mocha -- -u exports --compilers ls:LiveScript test/*.ls

coverage-report: coverage/index.html

coverage/index.html: cover
	node_modules/.bin/istanbul report html

watch:
	fswatch src:test 'make coverage-report'
