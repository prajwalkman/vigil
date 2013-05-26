{sinon, should} = require './runner'

cluster = require 'cluster'
overseer = require '../overseer'

describe 'Overseer master process', ->
    it 'should fork three times', ->
        forkSpy = sinon.spy cluster, "fork"
        overseer()
        forkSpy.should.have.been.calledThrice
