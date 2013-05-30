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
    fs             = require 'fs'
    pidStatsProto  = require './pid_stat_proto'
    procStatsProto = require './proc_stat_proto'
    {exec}         = require 'child_process'
    q              = require 'q'
    glob           = require 'glob'
    readFile       = q.denodeify fs.readFile


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
                promises = _.map pidFiles, (file) -> readFile file
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
                    deferred.reject new Error "No files matched pattern '#{pid}'"
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


        getPidStats: ->
            throw "Premature pidStats" unless @pid?
            fs.readFile "/pid/#{@pid}/stat", (err, data) ->
                throw err if err
                statArray = data.split /\s/
                @stats = _.object pidStatsProto, statArray
        getProcStats: ->

    module.exports = Service
