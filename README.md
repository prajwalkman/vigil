vigil
=====

WORK IN PROGRESS
----------------

*A system and service monitoring framework based on NodeJS.*

Feature and pull requests welcome.

***

What about Monit?
-----------------

The next version of Monit *"will be based on a non-blocking event driven architecture"*. It's other goal is to make monitoring configuration expressive and extensible. Which is how a system monitoring service should always be.

It simply makes sense to use the most popular, tested and hardened event driven architecture for a software that's meant to never be down: NodeJS. It comes with a web server built in, and as a bonus, you also get the best ecosystem for extensibility and plugins:

* Low level configuration/plugins using JavaScript
* Declarative configuration using JSON
* DSL based configuration using CoffeeScript

In addition, Vigil's various components work independently, meaning failure in one component will not affect the others. The failed component will be killed off as gracefully as possible, and replaced with a new instance quickly.
