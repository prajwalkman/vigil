Index
=====

Overview
--------

The entry point for the application. Sets up configuration locals from the
environment or CLI arguments and the directories used for logging.

***

Source-through
--------------

    exports.flags = [
        "DISABLE_LOGGING"
        "DISABLE_RESTART"
    ]


    exports.settings =
        control_file: '/etc/vigil/vigil.json'
        service_dir: '/etc/vigil/vigil.d/'