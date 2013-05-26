{sinon, should} = require './runner'

resolver = require '../dependencies'

graph_valid =
    'myApp':     ['apache', 'passenger', 'mysql']
    'passenger': ['apache']
    'mysql':     []
    'apache':    []

graph_invalid =
    'myApp':     ['apache', 'passenger', 'mysql']
    'passenger': ['apache']
    'mysql':     []
    'apache':    ['passenger']

describe 'Dependency Resolver', ->
    it 'should return true when graph is valid', ->
        resolver(graph_valid).should.be.true

    it 'should throw error when graph is invalid', ->
        (-> resolver(graph_invalid)).should.throw Error
