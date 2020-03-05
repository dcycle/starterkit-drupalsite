Starterkit for a complete Drupal 8 site
=====

[![CircleCI](https://circleci.com/gh/dcycle/starterkit-drupal8site.svg?style=svg)](https://circleci.com/gh/dcycle/starterkit-drupal8site)

Contents
-----

* About
* Quickstart
* HTTPS quickstart
* Initial installation on Docker
* Incremental deployment (updating) on Docker
* ./scripts/docker-compose.sh instead of docker-compose
* Environment types
* Power up/power down the Docker environment
* Uninstalling the Docker environment
* Prescribed development process
* Patches
* Development design patterns
* Running automated tests
* Security and maintenance updates
* Theming
* Acquia
* Login links for Acquia environments
* Linting
* Getting a local version of the database
* Logging
* Logging emails during development
* Troubleshooting

About
-----

A starterkit to build a Drupal 8 project.

### Features

* **Docker-based**: only Docker is required to build a development environment.
* **One-click install**: a full installation should be available simply by running `./scripts/deploy.sh`.
* **Dependencies and generated files are not included in the repo**: modules, libraries, etc. should not be included in the repo. If you need to generate a directory with all dependencies and generated files, run `./scripts/create-build.sh`.
* **Sass is not used**: to keep the workflow simple, this project does not use SASS; we encourage direct modification of CSS. See the section "No SASS", below.

### Where to find the code

* The [code lives on GitHub](https://github.com/dcycle/starterkit-drupal8site).
* The [issue queue is on GitHub](https://github.com/dcycle/starterkit-drupal8site/issues).
* If you fork of copy this directory for your own project, enter other environments here (production, stage, secondary git origins).

Quickstart
-----

Step 1: Install [Docker](https://www.docker.com/get-docker) (nothing else required)

Step 2:

    cd ~/Desktop && git clone https://github.com/dcycle/starterkit-drupal8site.git
    cd ~/Desktop/starterkit-drupal8site && ./scripts/deploy.sh

Step 3: Click on the login link at the end of the command line output and enjoy a fully installed Drupal 8 environment.

HTTPS quickstart
-----

    cd ~/Desktop/starterkit-drupal8site && ./scripts/https-deploy.sh

See the article [Local development using Docker and HTTPS, Dcycle Blog, Oct. 27, 2018](https://blog.dcycle.com/blog/2018-10-27) for details on how this works.

Initial installation on Docker
-----

To install or update the code, install Docker and run `./scripts/deploy.sh`, which will give you a login link to a local development site.

Incremental deployment (updating) on Docker
-----

Updating your local installation is the same command as the installation command:

    ./scripts/deploy.sh

This will bring in new features and keep your existing data.

Environment types
-----

When you run ./scripts/deploy.sh, you can specify one of these **environment types**. If you do not specify an environment type, the "dev" environment type is used.

**dev** (default): used for local development.

* Opcache is turned off: PHP parses your code at every call, insteading of using optimization cache.
* Volumes are shared between your host and your container, meaning changes to your code on your host machine are used by your container.

**build**: used to build an image, potentially for storage on a Docker registry.

* Opcache is turned on because "build" mode is not designed to do development.
* Code is copied to the container, so your container will have everything it needs to run.

./scripts/docker-compose.sh instead of docker-compose
-----

The `docker-compose` command will, by default, use `docker-compose.yml`, but in our setup, `docker-compose.yml` by itself is not valid, because we have several environment types (dev, build, ...). Using `./scripts/docker-compose.sh` will find the right environment type based on the contents of the unversioned `.env` file. For example, if the environment type is "dev", we will use, automatically, `docker-compose.yml` but also `docker-compose.dev.yml` as described in ./scripts/dev/env.txt.

Power up/power down the Docker environment
-----

To shut down your containers but _keep your data for next time_:

    ./scripts/docker-compose.sh down

To power up your containers:

    ./scripts/docker-compose.sh up -d

Uninstalling the Docker environment
-----

To shut down your containers and _destroy your data_:

    ./scripts/destroy.sh

If your project is the only project using the local https via the [Nginx Proxy], you might want to destroy the nginx-proxy container

    docker kill nginx-proxy
    docker rm nginx-proxy

You might also want to remove, from /etc/hosts, the line which contains your local development domain (use `sudo vi /etc/hosts` to edit that file); and also remove the certificate for your domain from `~/.docker-compose-certs`.

Prescribed development process
-----

The development cycle is as follows:

* Download the latest code and run `./scripts/deploy.sh`.
* Perform your local development on a branch `my-feature`.
* Export your config changes to code using `./scripts/export-config.sh`.
* Merge the latest version of master and run `./scripts/deploy.sh`.
* Push to Github and open a pull request.
* Self-review or have a colleague review code in the pull request.
* Make sure automated tests and linting is passing using `./scripts/test.sh`
* Use Github's GUI to **Squash and merge** your branch for clean git history.
* Use Github's GUI to delete your branch.
* Delete your branch locally and switch back to master.
* Pull the latest version of master.

Developers should also read this entire ./README.md file and add to it any information which may be useful for other developers.

Patches
-----

If you need to apply a patch, make sure it is published on Drupal.org in an issue, and apply it in the Dockerfiles. See ./Dockerfile for an example.

Development design patterns
-----

If you are looking at the code for the first time, here are a few design patterns and approaches which explain some of the choices which were made during the development process:

### Do not commit code which can be dowloaded or generated

We are not committing code such as downloaded modules, keeping the codebase rather small.

### No SASS

We do not use SASS in this project to avoid complexity. If you want to implement SASS support, consider the following questions:

* Generated CSS should be created in the build phase by `./scripts/create-build.sh`. Because we only allow Docker as a dependency of this project, you might consider a technique such as the one outlined in ["Compass Sass to CSS using Docker", Feb. 9, 2016, Dcycle blog](http://blog.dcycle.com/blog/107/compass-sass-css-using-docker/).
* You should not commit generated CSS to this git repo. You might need to `.gitignore` certain files, or make sure they reside on the container, but not your local computer.
* Do you need a real-time compiler directly embedded in your container?

### Docker-based one-click development setup

./scripts/deploy.sh is designed to use Docker to set up everything you need to have a complete environment.

### Common code as traits

We make use of traits to allow classes to implement common code and the Singleton design pattern (see ./drupal/custom-modules/my_custom_module/src/App.php and ./drupal/custom-modules/my_custom_module/my_cystom_module.module for usage).

Running automated tests
-----

Developers are encouraged to run `./scripts/test.sh` on their machine. If you have Docker installed, this will work without any further configuration.

This lints code (that is, it checks code for stylistic errors) and runs automated unit PHPUnit tests. If you get linting errors you feel do not apply, see a workaround in the "Linting" section, below.

We are not using Drupal's automated testing framework, rather:

* PHPUnit is used to test the code;
* Any Drupal-specific code is wrapped in methods `./drupal/custom-modules/my_custom_module/src/traits/Environment.php`, then mocked in the unit tests. See `./drupal/custom-modules/my_custom_module/test/AppTest.php` for an example.
* Running tests is done using `./scripts/test.sh` (which includes linting) or `./scripts/unit.sh` (which does not include linting), requiring only Docker and no additional setup.

Security and maintenance updates
-----

Because our git repo does not contain actual Drupal or module code, it downloads these each time ./scripts/deploy.sh is run, so simply running ./scripts/deploy.sh will update everything to the latest version.

Theming
-----

We are using the [CDN Drupal Bootstrap subtheme](https://drupal-bootstrap.org/api/bootstrap/starterkits%21cdn%21README.md/group/sub_theming_cdn/8).

Acquia
-----

This project provides some integration with Acquia Cloud.

### Prerequisites on the Acquia server

* We need to install the same version of PHP as can be found on the containers by typing `./scripts/docker-compose.sh exec drupal /bin/bash -c 'php -v'`.
* Make sure you are periodically calling "drush cron" from the command line using [this technique](https://docs.acquia.com/acquia-cloud/manage/cron) on your Acquia site.

### Notes about cron on Acquia

Acquia suggests [this technique](https://docs.acquia.com/acquia-cloud/manage/cron) for setting up cron.

    drush @MY-ACQUIA-ACCOUNT -dv -l http://my-site-on-acquia.example.com cron &>> /var/log/sites/${AH_SITE_NAME}/logs/$(hostname -s)/drush-cron.log

### Do not modify the Acquia git code directly, "build" it instead

Run ./scripts/create-build.sh

Login links for Acquia environments
-----

    ./scripts/acquia/uli.sh

Linting
-----

We use a [PHP linter](https://github.com/dcycle/docker-php-lint) and other linters in ./scripts/lint.sh. If your code is not commented correctly or structured correctly, Circle CI continuous integration will fail. See the linter documentation on how to ignore certain blocks of code, for example `t()` is ignored in ./drupal-server/custom-modules/my_custom_module/src/traits/Utilities.php.

    // @codingStandardsIgnoreStart
    ...
    // @codingStandardsIgnoreEnd

Getting a local version of the database
-----

If you have a .sql file with the database database, you can run:

./scripts/docker-compose.sh exec drupal /bin/bash -c 'drush sqlc' < /path/to/db.sql

You can set up the Stage File Proxy module to fetch files from the live server instead of importing the files.

Logging
-----

We are [using syslog instead of dblog](https://www.drupal.org/docs/8/core/modules/syslog/overview) for speed and ease of use. This means you will not have access to log messages through the administrative interface.

To access logs you can then use

    tail \
      -f ./do-not-commit/log/drupal.log \

Or the Mac OS X Console application.

Logging emails during development
-----

We are using a dummy email server with a full GUI, [Mailhog](https://github.com/mailhog/MailHog), as a destination for our emails during development. This is described in [Debug outgoing emails with Mailhog, a dummy mailserver with a GUI, March 14, 2019, Dcycle Blog](https://blog.dcycle.com/blog/2019-03-14/mailhog/).

Here is how it works:

When you create or update your environment ./scripts/deploy.sh, or at any time by running ./scripts/uli.sh, you will see something like:

    => Drupal: http://0.0.0.0:32783/...
    => Dummy email client: http://0.0.0.0:32781

The ports will be different each time, but using the above ports as an example, you can:

(1) visit http://0.0.0.0:32783/user/password
(2) enter "admin"
(3) you should see "Further instructions have been sent to your email address."
(4) to view the actual email in a GUI, visit (in this example) http://0.0.0.0:32781


Troubleshooting
-----

### First steps if anything goes wrong

Make sure you completely delete your environment using:

    ./scripts/docker-compose.sh down -v

Make sure you have the latest stable version of your OS and of Docker.
If you're really in a bind, you can do a factory reset of Docker (which will kill your local data).
Make sure Docker has 6Gb of RAM. (On Mac OS, for example, this can be done using Docker > Preferences > Advanced, then restarting Docker).

Rerun `./scripts/deploy.sh`, and reimport the stage database if you need it (see "Getting a local version of the database", above).

### ./scripts/docker-compose.sh down -v results in a network error

If you run `docker network rm starterkit_drupal8site_default` and you get "ERROR: network starterkit_drupal8site_default id ... has active endpoints", you might need to disconnect the Drupal 7 site from the Drupal 8 network first. This should be done in the migration process, but it might not have worked. If such is the case, type:

    docker network disconnect starterkit_drupal8site_default $(./scripts/docker-compose.sh ps -q database)

### Beware case-sensitivity

Docker is meant to mimic the Acquia environment relatively well, but there can be certain differences, for instance:

* if you `use path/to/class` instead of `path/To/Class`, it will work in Docker (local) and in automated tests, but fail on Acquia.

### ./scripts/docker-compose.sh build --no-cache

Docker will, by default, used cached versions of each step of the build process for images. For example:

    FROM ubuntu
    RUN apt-get install something

If you _know_ "something" has changed, you might want to run:

    ./scripts/docker-compose.sh build --no-cache
    ./scripts/deploy.sh

### Can't see the syslogs (see the "Logging" section, above)

Run `./scripts/deploy.sh`, which will restart rsyslog.
