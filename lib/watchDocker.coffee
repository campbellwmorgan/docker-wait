###
Runs docker logs operation
and blocks until regex match
made
###
exec = require('child_process').exec

###
@param {string} container
@param {RegExp} regular expression
@param {Function} (error) ->
@param {Object} options
###
module.exports = (container, regex, cb, opts) ->
  exited = false
  command = opts.coreCommand container

  console.log "executing #{command}"

  childProcess = exec command

  killChild =->
    # try to kill the
    # log watch
    if childProcess and
    'kill' of childProcess
      childProcess.kill()
    exited = true
    childProcess = false

  childProcess.stdout.on 'data'
  , (data) ->
    if opts.logOutput
      console.log data
    # if the output matches
    # the regex exit
    if data.match(regex)

      killChild()
      # call the callback
      cb()

  childProcess.on 'error', (err)->
    cb(err)
    killChild()

  childProcess.on 'exit', (code) ->
    return if exited
    # as this is executing
    # the docker follow logs
    # command, we assume
    # any exit is an error
    cb new Error("Tail exited with code " + code)
    killChild()
