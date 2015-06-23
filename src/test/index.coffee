TransInterpolator	= require '../TransInterpolator'
unit				= require 'nodeunit'

inspect = (val) -> require('util').inspect val, { depth: 5, colors: true, hidden: true }
data = {
	variable:
		here: -> '{{ variable.is.b3 }}1'
		is: {
			b2: 100
			b3: 'wowo'
		}
	
	some: { thing: 'b2' }
}

console.log(
	'------ test1'
	inspect new TransInterpolator(data).interpolate """blah blah {{variable.here}}"""
)

console.log(
	'------ test2'
	inspect new TransInterpolator(data).interpolate """blah blah {{some.thing}} {{variable.is['{{some.thing}}']}}""", (val) ->
		return val
)