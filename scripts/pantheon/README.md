The scripts herein are designed to help you manage environments on Pantheon.

Setup
-----

Please update `./config/versioned.source.sh` and `./config/unversioned.source.sh` with information about your Pantheon environment. See `./config/versioned.source.sh` and `./config/unversioned.source.example.sh` for details.

Config split
-----

Traditionally Dcycle Drupal Starterkit projects have performed a custom version of config split for Acquia targets, whereby certain operations (such as temporarily storing form configuration, then combining with newly importe configuration), acted as a sort of config-split-like feature, allowing, for example, webforms to be treated as data. At the time of this writing we are not implement this for Pantheon environments. All local config will overwrite remote config.

Using terminus and drush
-----

Terminus is a API for Pantheon; it can be used to run Drush commands. Contrary to Acquia, you cannot SSH directly into your pantheon servers.

Here is how to use Terminus and Drush (once your configuration is set up correctly -- see "Setup", above):

    ./scripts/pantheon/terminus.sh
    ./scripts/pantheon/terminus.sh site:list
    ./scripts/pantheon/drush.sh dev pml

Moving your site to Pantheon dev
-----

This is typically done at the very start of the project. We move database, code and files to pantheon.

This will entail a few manual steps but the script will tell you what to do:

    ./scripts/pantheon/from-local.sh dev

The above script includes the build script (see below).

Building your local site
-----

Here is what we mean by building: taking code from your docker container, and moving it to the Pantheon git repo, and then to the Pantheon dev server, and finally running drush cim and drush updb. Here is how to do this:

    ./scripts/pantheon/build.sh
