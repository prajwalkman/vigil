resolver = require '../src/dependencies'

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

graph_empty = {}

describe 'Dependency Resolver', ->
    it 'should return true when graph is valid', ->
        resolver(graph_valid).should.be.true

    it 'should throw error when graph is invalid', ->
        (-> resolver(graph_invalid)).should.throw Error

    it 'should return true when graph is empty', ->
        resolver(graph_valid).should.be.true
