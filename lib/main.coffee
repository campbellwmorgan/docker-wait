###
Docker-Wait

Blocks until regex match found in log
output from docker

Useful for deployment bash scripts for ensuring
that servers are fully loaded

Copyright Campbell Morgan 2014

Licence MIT
###

fs = require 'fs'
_ = require 'lodash'
watchDocker = require './watchDocker'
async = require 'async'

defaults =
  # 60 second timeout before
  # quitting
  timeout: 60

  # core command (can be overwritten)
  coreCommand: (container) ->
    "docker logs -f #{container}"

  # log output to cli
  logOutput: true

  containers: [
  ]

argv = require('optimist').argv

errorExit = (message) ->
  console.error message
  process.exit(1)

# exit unless there's a config file
unless argv._.length
  errorExit "Usage: docker-wait [config-file.json|js|coffee]"

configFile = argv._[0]

# check the config file
# actually exists
unless fs.existsSync(configFile)
  errorExit "specified config file not found"

configPath = fs.realpathSync(configFile)

# check whether the config file
# is json
if configFile.match /\.json$/

  contents = fs.readfileSync(configPath)

  unless contents
    errorExit "Config file empty"

  userOptions = JSON.parse(contents)
  unless data
    errorExit "Could not parse JSON"


else

  userOptions = require(configPath)


opts = _.extend defaults, userOptions

###
Ensure process exits after timeout
###
setTimeout ->
  errorExit "Timeout Limit reached"
, (1000 * opts.timeout)


###
Listen to logs for each container

###

# create an array of functions
# of all the containers to add to
# async.parallel
containerFunctions = _.map opts.containers
, (regex, container) =>
  # function that is
  # executed by async.parallel
  func = (callback) ->
    watchDocker(
      container
      regex
      callback
      opts
    )

async.parallel containerFunctions
, (err, res) ->

  if err
    console.error err
    errorExit "process threw an error"

  # all processes finished
  console.log "All matches found"
  process.exit()

