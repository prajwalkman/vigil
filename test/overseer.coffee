sinon = require './runner'

cluster = require 'cluster'
overseer = require '../src/overseer'

forkSpy = sinon.spy cluster, "fork"

describe 'Overseer master process', ->
    it 'should fork three times', ->
        forkSpy.reset()
        master = overseer()
        forkSpy.should.have.been.calledThrice

    it 'should fork when a child dies', ->
        master = overseer()
        forkSpy.reset()
        master.cluster.workers[2].kill()
        assertion = ->
            forkSpy.should.have.been.calledOnce
        setTimeout assertion, 10
