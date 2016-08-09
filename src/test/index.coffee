TransInterpolator = require '../TransInterpolator'
unit              = require 'nodeunit'

console.inspect = (val) -> console.log require('util').inspect val, { depth: 5, colors: true, hidden: true }

data = {
    variable:
        here: -> '${ variable.is.b3 }1'
        is: {
            b2: 100
            b3: 'wowo'
        }

    some: { thing: 'b2' }
}

exports['from string to function to string'] = (test) ->
    interpolator = new TransInterpolator(data)

    expected = """blah blah wowo1"""
    actual   = interpolator.interpolate("""blah blah ${variable.here}""")

    test.equal(actual, expected)
    test.done()


exports['nested string with interpolated key'] = (test) ->
    interpolator = new TransInterpolator(data)

    expected = """blah blah b2 100"""
    actual   = interpolator.interpolate(
        """blah blah ${ some.thing } ${ variable.is['${ some.thing }'] }""",
        (val) -> val
    )

    test.equal(actual, expected)
    test.done()



exports['uses different open and close tags'] = (test) ->

    class CustomTransInterp extends TransInterpolator
        open: '{{'
        close: '}}'

    interpolator = new CustomTransInterp(
        {
            variable:
                here: -> '{{ variable.is.b3 }}1'
                is: {
                    "{{ b2 }}": 100
                    b3: 'wowo'
                }

            some: { thing: 'b2' }
        }
    )

    expected = """blah blah wowo1 100"""
    actual   = interpolator.interpolate(
        """blah blah {{ variable.here }} {{ variable.is['\\{{ {{ some.thing }} \\}}'] }}""",
        (val) -> val
    )

    test.equal(actual, expected)
    test.done()
