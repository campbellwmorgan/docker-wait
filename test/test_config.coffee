module.exports =
  timeout: 10

  coreCommand: (container) ->
    "tail -f #{container}"

  containers:
    "/tmp/docker-wait-test1.txt": /test1/
    "/tmp/docker-wait-test2.txt": /test2/

