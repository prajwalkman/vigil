    os = require 'os'

    module.exports = switch os.platform()
        when 'darwin'
            [
                'user'
                'processId'
                'percentageCpu'
                'percentageMemory'
                'virtualSize'
                'residentSetSize'
                'terminal'
                'status'
                'startTime'
                'cpuTime'
                'command'
                'uid'
                'parentPid'
                'cpu'
                'priority'
                'niceness'
                undefined
            ]
