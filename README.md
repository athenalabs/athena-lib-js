# athena.lib.js

[Athena](http://athena.ai) JS Library

This is a collection of commonly used utility classes and functions.
It is tiny, but is separated since it is used in
[acorn-player](http://github.com/athenalabs/acorn-player)

## Setup
### install dependencies

* [node and npm](http://nodejs.org/download/)
    or in osx:

        brew install nodejs

* [phantomjs](http://phantomjs.org/)
    or in osx:

        brew install phantomjs

* [closure compiler](http://code.google.com/p/closure-compiler/downloads/list)
    or in osx:

        brew install closure-compiler

### setup google closure

Move (or create a symlink to) the closure compiler jar to
`lib/closure/compiler.jar`. For example, in osx:

    % mv ~/Downloads/compiler-latest/compiler.jar lib/closure/.

or

    % ln -s /usr/local/Cellar/closure-compiler/20120917/libexec/build/compiler.jar lib/closure/.

Initialize google closure-tools submodule:

    % git submodule init
    % git submodule update

### install node modules

    % npm install


## source tree

The codebase is organized thus:

    ├── Gruntfile.coffee - the grunt task file
    ├── README.md        - this file
    ├── build            - the build directory, for compiled code
    ├── coffee           - coffeescript code
    │   ├── src          - coffeescript source files
    │   └── test         - coffeescript test files
    ├── js               - javascript code (generated from coffee/)
    │   ├── deps.js      - generated dependencies file (closure)
    │   ├── src          - javascript source files
    │   └── test         - javascript test files
    ├── lib              - libraries
    │   ├── bootstrap    - bootstrap js/css library
    │   └── closure      - closure library + compiler
    ├── node_modules     - npm installed modules
    └── package.json     - package info


## grunt tasks

Available tasks (ignore others):

        coffee  Compile CoffeeScript files (coffee/ to js/)
          deps  Generates file dependencies (js/deps.js)
          test  Runs jasmine tests in the commandline.
    testserver  Runs jasmine tests in a webserver.
       compile  Closure compiles the source (js/src/).
       default  Alias for "compile" task.
         watch  Watches coffee/ and re-runs "deps"
         clean  Clear files and folders (js/, build/)

Common workflow:

* write code in `coffee/src/`
* write corresponding tests in `coffee/test/`
* test with `grunt --config Gruntfile.coffee test`
* test with `grunt --config Gruntfile.coffee testserver`
* compile code with `grunt --config Gruntfile.coffee compile`


## testing
### writing specs

Write your [jasmine specs](http://pivotal.github.com/jasmine/#section-Suites:_<code>describe</code>_Your_Tests) in the `test` part of the source tree. Your `test` directory should mirror your `src` directory, with every `filename.{coffee,js}` having a corresponding `filename.spec.{coffee,js}`. This one-to-one `test` to `src` correspondence:

* makes sure you do write a `test` file for every `src` file.
* easily identifies and properly scopes spec files, for simpler debugging.

For example, in coffeescript:

    coffee
    ├── src
    │   ├── hello.coffee
    │   └── main.coffee
    └── test
        ├── hello.spec.coffee
        └── main.spec.coffee

And in javascript:

    js
    ├── deps.js
    ├── src
    │   ├── hello.js
    │   └── main.js
    └── test
        ├── hello.spec.js
        └── main.spec.js

### running from the command line

You can run the tests from the commandline (using phantomjs):

    grunt --config Gruntfile.coffee test

![test](http://static.benet.ai/skitch/saucer-test-20121208-035832.png)

### running with a webserver

You can run the tests from the commandline (using phantomjs):

    grunt --config Gruntfile.coffee testserver

![server](http://static.benet.ai/skitch/saucer-webserver-20121208-043214.png)

![web-all](http://static.benet.ai/skitch/saucer-all-20121208-040013.png)


## Further Documentation

athena.lib.js is built on top of the [Saucer](https://github.com/jbenet/saucer) boilerplate. See the [Saucer documentation](https://github.com/jbenet/saucer/blob/master/README.md) for more details about the toolchain and build system.
