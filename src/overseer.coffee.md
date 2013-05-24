Overseer
========

Overview
--------

This module oversees the creation and maintenance of the Vigil process
cluster. It spins off child processes which each perform a specific role
(server, monitor, etc). Each worker runs in a `domain`. When the worker
encounters an uncaught exception, it is allowed to gracefully die, and a new
fork is created here to replace it.

***

Source-through
--------------

First, require the cluster module.

    cluster = require 'cluster'


This sets the configuration for `cluster.fork()`. 

*The new settings are effective immediately and permanently, they cannot be
changed later on.

    overseerConfig =
        exec:   require.resolve('./workers')
        args:   []
        silent: false

    cluster.setupMaster overseerConfig

A list of the various well defined roles taken on by our workers.

    roles = [
        'server'
        'monitor'
        'runner'
    ]

We can set environment variables for the child while forking. Here, we set the
`role` environment variable so the worker knows what it's supposed to do. We
loop through `roles` creating a worker for each, and storing their reference
in the hash table `workers`.

    workers = {}
    workers[role] = cluster.fork(role: role) for role in roles

The `resurrectionHandler` is called when a worker dies. We figure out it's
role form `worker.id` and fork() a new worker of that role to replace the dead
one.

    resurrectionHandler = (worker, code, signal) ->
        workerRole = 'runner'
        workerId = worker.id
        console.log "Worker {ID: #{workerId}, ROLE: #{workerRole}} has " + 
            "died. Restarting..."
        workers[workerRole] = cluster.fork role: workerRole

    cluster.on 'exit', resurrectionHandler

A callback to ensure graceful death of the master process.

    masterExitHandler = ->
        console.log "\nVigil is quitting."

    process.on 'SIGINT', ->
        process.exit 1

    process.on 'exit', masterExitHandler