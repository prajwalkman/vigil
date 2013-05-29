parse = require '../src/config/parser'
vm = require 'vm'

mockFileValid = __dirname + '/mocks/parser_mock_valid.conf'
mockFileInvalid = __dirname + '/mocks/parser_mock_invalid.conf'

expectedResult =
    alpha:
        val: 1
    beta:
        val: 2
    gamma:
        val: "sample"

describe 'Configuration DSL parser', ->
    it 'should return value as object', ->
        parse(mockFileValid).should.become expectedResult

    it 'should throw error when file doesnt exist', ->
        parse('nonexistantfile').should.be.rejected.with Error, "ENOENT"

    it 'should throw compile error when file content is invalid', ->
        parse(mockFileInvalid).should.be.rejected.with SyntaxError
