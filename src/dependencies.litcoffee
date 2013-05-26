Dependencies
=====================

Overview
--------

Check dependency graph for cycles. Throw a `CycleError` if one is found, detailing the services involved.

***

Source-through
--------------

    _ = require 'underscore'

    class CycleError extends Error
        constructor: (dependency, walkedList) ->
            index = _.indexOf walkedList, dependency
            cycle = _.reject walkedList, (s) -> _.indexOf(walkedList, s) < index
            cycle.push dependency
            @message = "Cyclic Dependency found: '#{cycle.join '\' -> \''}'"
        name: 'Cyclic Dependency Error'

    module.exports = (graph) ->
        services = _.keys graph
        visited = []

        visitNode = (service, walked) ->
            walked = [] unless _.isArray walked
            visited.push service
            walked.push service
            visitDependencies = (dependency) ->
                if _.contains walked, dependency
                    throw new CycleError dependency, walked

                visitNode dependency, walked.slice 0

            _.each graph[service], visitDependencies

        _.each services, visitNode

        return true

