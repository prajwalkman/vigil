chai            = require 'chai'
sinonChai       = require 'sinon-chai'
chaiAsPromised  = require 'chai-as-promised'
mochaAsPromised = require 'mocha-as-promised'

should = chai.should()
chai.use sinonChai
chai.use chaiAsPromised
mochaAsPromised()

