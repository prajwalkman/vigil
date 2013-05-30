Service = require '../src/prototypes/service_proto'
_ = require 'underscore'

pidFiles = [
    'pid1.pid'
    'pid2.pid'
    'pid3.pid'
]

pidFiles = _.map pidFiles, (file) ->
    __dirname + '/mocks/service_proto_mock/' + file

pidFilesGlob = __dirname + '/mocks/service_proto_mock/' + '*.pid'
pidFilesGlobInvalid = __dirname + '/mocks/service_proto_mock/' + '*.nonexistantextension'

expectedPids = [500, 1200, 300]

describe 'ServiceProto', ->
    it 'should return array of pids', ->
        s = new Service pidConfig: pidFiles
        s.getPids().should.become expectedPids

    it 'should return array of single pid', ->
        index = 1
        s = new Service pidConfig: pidFiles[index]
        s.getPids().should.become [expectedPids[index]]

    it 'should reject with error when file doesnt exist', ->
        s = new Service pidConfig: 'nonexistantfile'
        s.getPids().should.be.rejected.with Error, 'ENOENT'

    it 'should reject exact error when file doesnt exist', ->
        newPidFiles = pidFiles.concat 'nonexistantfile'
        s = new Service pidConfig: newPidFiles
        s.getPids().should.be.rejected.with Error, /.*ENOENT.*nonexistantfile.*/

    it 'should return array of pids when glob is passed', ->
        s = new Service pidConfig: pidFilesGlob
        s.getPids().should.become expectedPids

    it 'should throw error when no matches for glob', ->
        s = new Service pidConfig: pidFilesGlobInvalid
        s.getPids().should.be.rejected.with Error, "pattern"
