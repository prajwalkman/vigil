Services
========

Overview
--------

Here we load and parse user configuration files, build service dependency graphs, check for issues (dependency loops, invalid configurations) and build `Service` objects used by the Monitor.

***

Source-through
--------------

    settings = require('./index').settings
