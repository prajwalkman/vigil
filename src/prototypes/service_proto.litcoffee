Service
=======

Overview
--------

A template for the Service object.

***

Source-through
--------------

    _              = require 'underscore'
    _.str          = require 'underscore.string'
    pidStatsProto  = require './pid_stat_proto'
    procStatsProto = require './proc_stat_proto'
    {exec}         = require 'child_process'
    q              = require 'q'
    glob           = require 'glob'
    fs             = require 'q-io/fs'


    class Service
        constructor: (config) ->
            {
                @name
                @startCmd
                @stopCmd
                @reloadCmd
                @pidConfig
                @procConfig
                @watchers
                @reporters
                @failover
                @groups
                @uid
                @gid
                @cwd
                @env
                @chroot
            } = config

        getPids: ->
            deferred = q.defer()
            pid = @pidConfig
            pidFiles = []
            proc = @procConfig

            reader = ->
                promises = _.map pidFiles, (file) -> fs.read file
                failureCallback = (error) ->
                    deferred.reject error
                successCallback = ->
                    contents = _.map promises, (promise) ->
                        parseInt promise.valueOf().toString().trim()
                    deferred.resolve contents
                q.all(promises).then successCallback, failureCallback

            globCallback = (error, files) ->
                if error
                    deferred.reject error
                else if _.isEmpty files
                    deferred.reject new Error "No files matched '#{pid}'"
                else
                    pidFiles = pidFiles.concat files
                reader()

            if _.isEmpty proc
                if _.isString(pid) and pid.match(/\*+/)
                    glob pid, globCallback
                else
                    if _.isString pid
                        pidFiles.push pid
                    else if _.isArray pid
                        pidFiles = pidFiles.concat pid
                    reader()
            return deferred.promise

        getPidStats: (pids) ->
            deferred = q.defer()
            stats = []
            files = _.map pids, (pid) -> "/proc/#{pid}/stat"
            exists_promises = _.map files, (file) -> fs.exists file
            q.all(exists_promises).then ->
                exists_array = _.map exists_promises, (promise) ->
                    promise.valueOf()





        getProcStats: ->

    module.exports = Service
