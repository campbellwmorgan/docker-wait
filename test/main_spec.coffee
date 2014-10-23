exec = require('child_process').exec
fs = require 'fs'

describe "main watcher", ->

  it "Should exit after two temp file output matches regex", (done) ->

    testFile1 = '/tmp/docker-wait-test1.txt'
    testFile2 = '/tmp/docker-wait-test2.txt'
    if fs.existsSync testFile1
      fs.unlinkSync testFile1

    if fs.existsSync testFile2
      fs.unlinkSync testFile2


    # create the temp files
    fs.writeFileSync testFile1, 'init data'
    fs.writeFileSync testFile2, 'init data'

    # execute bash file with binary
    proc = exec './test/test.sh'

    proc.on 'exit', (code, res) ->
      if code isnt 0
        console.log code, res, 'exit'

    initDataReceived = false
    proc.stdout.on 'data', (data) ->
      console.log 'output', data
      if data.match /init data/
        initDataReceived = true

      if data.match /watchover/g
        # so test passes
        expect(initDataReceived).toBe(true)
        done()

    # now add lines to files that
    # trigger responses
    fs.appendFileSync testFile1, 'test1'
    fs.appendFileSync testFile2, 'test2'

