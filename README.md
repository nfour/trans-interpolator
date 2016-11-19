# TransInterpolator

Combines
- Variable **transposition** ( via [Transposer](http://npmjs.com/package/transposer) )
- Recursive string **interpolation**

```js
import TransInterp from 'trans-interpolator';

const interp = new TransInterp({
    some: [
        { "!data!": '5000' }
    ]
});

interp.interpolate("Total: ${ some[0]['!data!'] }.");
// returns "Total: 5000."
```

It's also rescursive.

```js
import math from 'mathjs' // http://mathjs.org

const interp = new TransInterp({
    price: 5000,
    expressions: {
        a: '${price}',                      // 5000
        b: '${expressions.a} * 1.5 / 2',    // 3750
        c: '${expressions.b} - ${getOne}',  // 3749
    },
    getOne: (value) => "( ${price} - ${price} ) + 1"
});

interp.interpolate("Computed to: ${ expressions.c }", (value) => {
    return math.eval(value);
});
// returns "Computed to: 3749"
```

It can be configured in two ways:

```js
import TransInterp from 'trans-interpolator';

new TransInterp({ data: 1 }, {
    open: "!!!",
    close: "^^^",
    transform(value, dataKey, expression) {
        return ` :D ${value} :D `;
    }
});
```

or

```js
import Base from 'trans-interpolator';

export class TransInterp extends Base {
    open = "<%"
    close = "%>"
    depth = 8
};

const transInterp = new TransInterp({})
```

## API

### class `TransInterpolator([data], [[options]])`
- `data`
    - The data to pull in; can contain expressions of itself.
    - When an expression resolves to a function, it will be treated just like a `transform` function.
- `options`
    - `depth = 8` Limit the recursion depth.
    - `open = "${"` The open tag
    - `close = "}"` The end tag
    - `transform(value, unresolved, expression) {}`


### method `.interpolate([expression], [[transform]])`
- `expression {String}`
- `transform(value, unresolved, expression) { return value; }`
    - Called when either no open tags are found or when the depth limit is met
    
