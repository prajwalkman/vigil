Parser
======

Overview
--------

This is used to parse configuration files written in our DSL.

***

Source-through
--------------

We will compile the config file programmatically using coffee-script to its equivalent javascript. We also use `Q` promise objects to simplify both the API and the unit tests.

    coffee = require 'coffee-script'
    fs     = require 'fs'
    path   = require 'path'
    vm     = require 'vm'
    q      = require 'q'

The sandbox object contains the functions required for parsing the contents of the config file.

    sandbox =
        as: (val) -> val: val

We evaluate the generated javascript in the context of the sandbox, and return the result. Errors cause the promise to be rejected.

    parser = (file) ->
        deferred = q.defer()
        fs.readFile path.resolve(file), (err, data) ->
            if err
                deferred.reject err
            else
                try
                    compiled_javascript = coffee.compile data.toString(), bare: true
                catch compile_error
                    deferred.reject compile_error
                result = vm.runInNewContext compiled_javascript, sandbox
                deferred.resolve result
        return deferred.promise

    module.exports = parser
