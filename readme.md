# TransInterpolator
Combines
- Variable transposition ( via [Transposer](http://npmjs.com/package/transposer) )
- Recursive string interpolation

```js
interpolator = new TransInterpolator({
	some: [ { "!data!": { please: '5000' } } ]
})

// The expressions can have leading and trailing whitespace
expression = "Total price: ${{ some[0]['!data!'].please }}."

interpolator.interpolate( expression ) // returns "Total Price: $5000."
```

It's also
- Recursive
- Allows for a value transformer function

```js
TransInterpolator = require 'trans-interpolator'
math = require('math') // http://mathjs.org/

interpolator = new TransInterpolator({
	price: 5000
	expressions: {
		a: '{{price}}' // 5000
		b: '{{expressions.a}} * 1.5 / 2' // 3750
		c: '{{expressions.b}} - {{someFn}}' // 3749
	}
	someFn: function(value, dataKey, expression) {
		return "1 + ( {{price}} - {{price}} )" // 1
	}
})
expression = "Computed to: {{expressions.c}}"

interpolator.interpolate(expression, function(value, dataKey, expression) {
	return math.eval( value )
})
// returns "Computed to: 3749"
```

### Install
`npm install trans-interpolator` (Browserify friendly)

### class TransInterpolator( data, ?options? )
- `data {Object}`
- `options {Object}` ( Optional )
	+ `callFunctions {Boolean}` ( Default `true` )
		* If a dataKey resolves to a function, call it and return its value
	+ `depth {Number}` ( Default `8` )
		* Determines how many recursions a value can undergo
	+ `open {String}` ( Default `{{` )
	+ `close {String}` ( Default `}}` )

### interpolate( expression, ?valueFunction? )
- `expression {String}`
- `valueFunction {Function}` ( Optional )
	+ Called when either no open tags are found or when the depth limit is met

