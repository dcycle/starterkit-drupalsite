Deploying to a Docker host
=====

This has been tested with DigitalOcean's one-click Docker environment.

Initial setup
-----

You can have as many docker environments as you wish; they can be on the same Docker host, or different hosts.

Each environment has its own set of config files. For example:

    ./config/docker-host/prod/versioned.source.sh
    ./config/docker-host/prod/unversioned.source.sh
    ./config/docker-host/stage/versioned.source.sh
    ./config/docker-host/stage/unversioned.source.sh
    ...

See ./config/docker-host/default/unversioned.source.example.sh for an example of what to put in ./config/docker-host/default/unversioned.source.sh.

This has been tested with 4Gb Docker hosts with backups enabled, on DigitalOcean.

Once you have set up your config files (in the above example for default--prod--and stage), run:

    export ENV=prod && ./scripts/docker-host/deploy.sh
