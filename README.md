# athena.lib.js

[Athena](http://athena.ai) JS Library

This is a collection of commonly used utility classes and functions.
It is tiny, but is separated since it is used in
[acorn-player](http://github.com/athenalabs/acorn-player)

## dev setup

* install node (v0.8.1)

    > brew install node

* install npm
* install phantomjs

    > brew install phantomjs

* install closure compiler

    > brew install closure-compiler

  * create a symlink to the closure-compiler jar to lib/closure.
    For example, in Mac OS X:

      > ln -s /usr/local/Cellar/closure-compiler/20120917/libexec/build/compiler.jar .

* install Node dependencies

    > npm install

* install grunt-cli

    > npm install grunt-cli


* initialize google closure-tools submodule:

    > git submodule init
    > git submodule update

TODO: build system should create `build` directory, as in, that's what build systems do.

## grunt tasks

TODO: document
