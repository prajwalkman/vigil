chai = require 'chai'
sinonChai = require 'sinon-chai'
sinon = require 'sinon'

should = chai.should()
chai.use sinonChai

exports.should = should
exports.sinon = sinon
