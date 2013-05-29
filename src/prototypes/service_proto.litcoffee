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
            if @pidLocation?
                fs.readFile @pidLocation, (err, data) ->
                    throw err if err
                    @pid.push parseInt data
                    @getPidStats()
            else if @processName
                exec "ps auxle | grep #{@processName}", (err, stdout, stderr) =>
                    throw err if err
                    console.error stderr if stderr
                    lines = _.str.lines stdout
                    lines = _.filter lines, (line) -> line
                    _.each lines, (line) =>
                        @pids.push _.object(procStatsProto, _.str.words line).processId

        getPidStats: ->
            throw "Premature pidStats" unless @pid?
            fs.readFile "/pid/#{@pid}/stat", (err, data) ->
                throw err if err
                statArray = data.split /\s/
                @stats = _.object pidStatsProto, statArray
        getProcStats: ->

    module.exports = Service
