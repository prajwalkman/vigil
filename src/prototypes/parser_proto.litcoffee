Parser
======

Overview
--------

This is used to parse configuration files written in our DSL.

***

Source-through
--------------

We will compile the config file programmatically using coffee-script to its equivalent javascript. We also use `Q` promise objects to simplify both the API and the unit tests.

    _              = require 'underscore'
    _.str          = require 'underscore.string'
    q              = require 'q'
    glob           = require 'glob'
    vm             = require 'vm'
    coffee         = require 'coffee-script'
    fs             = require 'q-io/fs'
    globber        = q.denodeify glob

The sandbox object contains the functions required for parsing the contents of the config file.

    sandbox =
        as: (val) -> val: val

We evaluate the generated javascript in the context of the sandbox, and return the result. Errors cause the promise to be rejected. In the specific case of errors in compiling the config file, we decorate the error with the file name.

    parser = (filenames) ->
        if _.isString filenames
            filenames = [filenames]
        deferred = q.defer()
        globPatterns = _.filter filenames, (name) -> name.match /\*+/
        rawNames = _.difference filenames, globPatterns
        filename_array = []
        fileContents = []
        results = []
        compiler = ->
            compile = (data) ->
                try
                    compiledCode = coffee.compile data.toString(), bare: true
                    vm.runInNewContext compiledCode, sandbox
                catch error
                    if error instanceof SyntaxError
                        index = _.indexOf fileContents, data
                        filename = filename_array[index]
                        message = error.message
                        newError = new SyntaxError "#{filename}: #{message}"
                        deferred.reject newError
                    else
                        deferred.reject error

            results = _.map fileContents, compile
            deferred.resolve results

        reader = (files) ->
            filename_array = _.uniq files
            promises = _.map filename_array, (file) -> fs.read file
            failureCallback = (error) -> deferred.reject error
            successCallback = (resolvedPromises) ->
                fileContents = resolvedPromises
                try
                    compiler()
                catch error
                    deferred.reject error
            q.all(promises).then successCallback, failureCallback

        globResolve = (patterns) ->
            successCallback = (promise_array) ->
                files = _.map promise_array, (promise) -> promise.valueOf()
                files = _.flatten files
                reader(rawNames.concat files)
            failureCallback = (error) -> deferred.reject error
            promises = _.map patterns, (pattern) -> globber pattern
            q.all(promises).then successCallback, failureCallback

        if _.isEmpty globPatterns
            reader(rawNames)
        else
            globResolve globPatterns

        return deferred.promise

    module.exports = parser
