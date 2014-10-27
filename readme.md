Docker Wait
============

A node.js binary that blocks until
a regex match has been made with output from docker logs.

The intended use is in bash files for server deployment
where you want to ensure that a docker container
has fully loaded

Must be run as root (in order to read your docker logs)


###Installation

        npm install -g docker-wait


###Usage

        docker-wait [path-to-config-file.json|coffee|js]



###Config File

  The binary blocks until the regex match
  has been with ALL listed containers

        {
          timeout: 30, // number of seconds to wait before exiting with error

          logOutput: true, // send the docker logs output to cli
          containers: {

            'container_name': /match this/g,
            'another_container_name': /Lisening on port \d{4}/
          }
        }


Copyright Campbell Morgan 2014

All Pull Requests welcome

Licence MIT

