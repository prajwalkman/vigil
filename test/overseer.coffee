sinon = require './runner'

cluster = require 'cluster'
overseer = require '../src/overseer'

describe 'Overseer master process', ->
    it 'should fork three times', ->
        forkSpy = sinon.spy cluster, "fork"
        master = overseer()
        forkSpy.should.have.been.calledThrice
