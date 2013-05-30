parser = require '../src/prototypes/parser_proto'
vm    = require 'vm'

mockFileBase          = __dirname + '/mocks/parser_proto_mock/'
mockFileAllGlob       = mockFileBase + '*.conf'
mockFileValidGlob     = mockFileBase + 'v*.conf'
mockFileDuplicateGlob = [mockFileValidGlob, mockFileValidGlob]

validResult = [
    {
        alpha: val: 11
        beta: val: 21
        gamma: val: 'sample1'
    },
    {
        alpha: val: 12
        beta: val: 22
        gamma: val: 'sample2'
    }
]

describe 'Configuration DSL parser', ->
    it 'should return array of config objects', ->
        parser(mockFileValidGlob).should.become validResult

    it 'should throw error', ->
        promise = parser(mockFileAllGlob)
        promise.should.be.rejected.with SyntaxError, "invalid.conf"

    it 'should drop duplicates', ->
        promise = parser(mockFileDuplicateGlob)
        promise.should.become validResult
