
{ spawn, spawnSync } = require 'child_process'

defaultArgs = [ '-c', '-o', '.', './src' ]

# Builds coffeescript from ./src to ./
build = (args = defaultArgs, done) ->
	coffee = spawn 'coffee', args
	
	coffee.stdout.on 'data', (data) -> console.log data.toString()
	coffee.stderr.on 'data', (data) -> console.error data.toString()
	coffee.on 'exit', (status) -> done?() if status is 0

task 'build', 'Build ./src to ./', ->
	build()

task 'watch', 'Build ./src to ./ and watch', ->
	build [ '-wc', '-o', '.', './src' ]
