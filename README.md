# TransInterpolator

Combines
- Variable **transposition** ( via [Transposer](http://npmjs.com/package/transposer) )
- Recursive string **interpolation**

```js
const interp = new TransInterpolator({
    some: [
        { "!data!": '5000' }
    ]
})

interpolator.interpolate("Total: ${ some[0]['!data!'] }.")
// returns "Total: 5000."
```

It's also rescursive.

```js
import TransInterp from 'trans-interpolator'
import math from 'mathjs' // http://mathjs.org

const interp = new TransInterp({
    price: 5000,
    expressions: {
        a: '${price}',                      // 5000
        b: '${expressions.a} * 1.5 / 2',    // 3750
        c: '${expressions.b} - ${getOne}',  // 3749
    },
    getOne: (value) => "( ${price} - ${price} ) + 1"
})

interp.interpolate("Computed to: ${ expressions.c }", (value) => {
    return math.eval(value)
})
// returns "Computed to: 3749"
```

It can also be configured in two ways

```js
import TransInterp from 'trans-interpolator'

new TransInterp({ data: 1 }, {
    open: "!!!",
    close: "^^^",
    transform(value, dataKey, expression) {
        return "woo" + value + "woo"
    }
})
```

or

```js
class TransInterp extends require('trans-interpolator') {
    open = "<%"
    close = "%>"
    depth = 8
}
```

## API

### `class TransInterpolator([data], [[options]])`
- `data`
    - The data to use when transposing. Can contain expressions itself.
    - When an expression resolves to a function in this object, it will be treated as a `transform` function
- `options`
    - `depth = 8` Limit the recursion depth.
    - `open = "${"` An open tag
    - `close = "}"` The end tag
    - `transform` A function which can be used mutate each resolved value


### `interpolate([expression], [[transform]])`
- `expression {String}`
- `transform(value, unresolved, expression)`
    - Called when either no open tags are found or when the depth limit is met
