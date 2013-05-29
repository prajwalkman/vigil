sinon = require 'sinon'

cluster = require 'cluster'
overseer = require '../src/overseer'


# describe 'overseer', ->

#     count = 1
#     stub = sinon.stub cluster, 'fork'

#     beforeEach ->
#         stub.reset()

#     it 'should fork three times', ->
#         master = overseer()
#         stub.should.be.calledThrice

#     it 'should fork when a child dies', ->
#         master = overseer()
#         stub.reset()
#         master.cluster.emit 'exit', {id: 2}
#         stub.should.be.calledOnce
