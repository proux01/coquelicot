Installation instructions
=========================

Prerequisites
-------------

You will need the Coq proof assistant (>= 8.8). You will need the
[MathComp](http://math-comp.github.io/math-comp/) library to be installed too.

The `.tar.gz` file is distributed with a working set of configure files. They
are not in the git repository though. Consequently, if you are building from
git, you will need `autoconf` (>= 2.59).


Configuring, compiling and installing
-------------------------------------

Ideally, you should just have to type:

    ./configure && ./remake && ./remake install

The environment variable `COQC` can be passed to the configure script in order
to set the Coq compiler command. The configure script defaults to `coqc`.
Similarly, `COQDEP` can be used to specify the location of `coqdep`. The
`COQBIN` environment variable can be used to set both variables at once.

The library files are compiled at the logical location `Coquelicot`. The
`COQUSERCONTRIB` environment variable can be used to override the
physical location where the `Coquelicot` directory containing these files
will be installed by `./remake install`. By default, the target directory
is `` `$COQC -where`/user-contrib ``.
