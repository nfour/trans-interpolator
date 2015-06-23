Transposer = require 'transposer'

module.exports = class TransInterpolator
	###
		@param data {Object}
		@param options {Object} (Optional)
	###
	constructor: (@data = {}, options) ->
		this[key] = val for key, val of options if options

		@openLength		= @open.length
		@closeLength	= @close.length
		@transposer		= new Transposer @data
		
	open	: '{{'
	close	: '}}'
	depth	: 8
	
	###
		Interpolates a string.
		
		@param expression {String}
		@param valueFn {Function} (Optional)
		@param depth {Number} (Optional)
	###
	interpolate: (expression, valueFn, depth = @depth) ->
		e			= expression
		positions	= []
		lastOpen	= expression.length
		
		# Check for 
		while ( newOpen = e.lastIndexOf @open, lastOpen ) > -1
			lastOpen	= newOpen
			open		= [ newOpen, newOpen + @openLength ]
			
			if not ( ( newClose = e.indexOf @close, open[1] ) > -1 )
				throw new Error "Missing close tag after open at `#{newOpen}`"
				
			close = [ newClose, newClose + @closeLength ]
			
			value		= e.slice( open[1], close[0] ).trim()
			resolved	= @transposer.get value
			
			if typeof resolved is 'function'
				resolved = resolved value, expression
			
			resolved += ''
			
			if depth > 0 and ( resolved.lastIndexOf @open ) > -1
				resolved = @interpolate resolved, valueFn, depth - 1
				
			resolved = valueFn resolved, value, expression if valueFn
			
			chars = e.split ''
			chars.splice open[0], close[1] - open[0], resolved
			
			e = chars.join ''

		
		return e
