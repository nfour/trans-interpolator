Transposer = require 'transposer'

module.exports = class TransInterpolator
    ###
        @param data {Object}
        @param options {Object} (Optional)
    ###
    constructor: (@data = {}, options) ->
        this[key] = val for key, val of options if options

        @openLength  = @open.length
        @closeLength = @close.length
        @transposer  = new Transposer @data

    open  : '${'
    close : '}'
    depth : 8

    ###
        Interpolates a string.

        @param expression {String}
        @param valueFn {Function} (Optional)
        @param depth {Number} (Optional)
    ###
    interpolate: (expression, transform = @transform, depth = @depth) ->
        e   = expression
        lastOpen = expression.length

        findClose = (fromIndex) =>
            closeStart = e.indexOf @close, fromIndex

            return closeStart if closeStart < 0

            # Skips escaped `close` tags
            if e[closeStart - 1] is '\\'
                return findClose closeStart + 1

            return closeStart

        # Loops over the the `expression` string backwards, finding `open` tags
        while ( openStart = e.lastIndexOf @open, lastOpen ) > -1
            openEnd  = openStart + @openLength
            lastOpen = openStart

            # Skips escaped `open` tags
            if e[openStart - 1] is '\\'
                lastOpen = lastOpen - 1
                continue

            # Recursively finds a `close` tag
            closeStart = findClose openEnd

            if closeStart < 0
                throw new Error "Missing close tag after open at `#{openStart}`"

            closeEnd = closeStart + @closeLength

            value = e.slice( openEnd, closeStart ).trim()

            # Removes escaping from `close` tags
            if ( escapedCloseAt = value.indexOf("\\#{@close}") ) > -1
                value = value.split('')
                value.splice(escapedCloseAt, 1)
                value = value.join('')

            # Removes escaping from `open` tags
            if ( escapedOpenAt = value.indexOf("\\#{@open}") ) > -1
                value = value.split('')
                value.splice(escapedOpenAt, 1)
                value = value.join('')

            # Resolves the variable key to a value
            resolved = @transposer.get value

            if typeof resolved is 'function'
                resolved = resolved resolved, value, expression

            # ensure string
            resolved += ''

            # Recurse
            if depth > 0 and ( resolved.lastIndexOf @open ) > -1
                resolved = @interpolate resolved, transform, depth - 1

            # Mutates with the `transform` callback if specified
            resolved = transform resolved, value, expression if transform

            chars = e.split ''
            chars.splice openStart, closeEnd - openStart, resolved

            e = chars.join ''

        return e
