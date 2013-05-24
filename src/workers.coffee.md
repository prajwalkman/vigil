Workers
=======

Overview
--------

This module acts as the base template for all `fork()`s by the Overseer.

***

Source-through
--------------

Required modules.

    cluster = require 'cluster'
    domain  = require 'domain'

Figure out this worker's role from its environment, and require the module for
that role.

    role = process.env.role

    worker = require "./#{role}"

Create a new domain within which the worker's code will be executed.

    workerDomain = domain.create()

When an error in the worker process bubbles up all the way to the event loop,
it is dangerous to continue running it, since it is technically in an
`undefined` state. To overcome this, we use the `errorHandler` to essentially
catch the error, call the worker's `cleanup()` method, and disconnect it from
the cluster. This emits the cluster's `exit` event, which is caught by the
master to replace this worker.

*`.unref()` which will allow you to create a timer that is active but if it is
the only item left in the event loop won't keep the program running.

    errorHandler = (error) ->
        console.error 
        try
            deathTimer = setTimeout (-> process.exit 1), 15000
            deathTimer.unref()
            worker.cleanup()
            cluster.worker.disconnect()
        catch deadlyError
            console.error "Error Handler Errored!"

    workerDomain.on 'error', errorHandler

    workerDomain.run worker.runner