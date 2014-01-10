# itertools-dart #

A collection of utilities for dealing with iterables in the dart language.

## Libraries ##

### yield ###

One of the sorely missed features of dart is the absence of the concept of a continuable generator.
The yield library exposes two top level functions, `yield` and `yieldAll`, which can be used to
create lazy generated iterables.

For examples of usage, see the various utility functions implemented in `itertools`

### itertools ###

A collection of utility functions for dealing with iterables in dart. Functions which can already
be found on the iterable interface are not defined here, but a number of other useful functions for
working with iterables are available from this library, including:

* `groupBy`: Group the elements of an iterable by a given key function
* `sort`: Lazily sort an iterable
* `reverse`: Lazily reverse an iterable.
* `innerJoin`, `leftOuterJoin`, `groupJoin`: Perform an `SQL` style JOIN operation on two iterables.
...and more.

A lot of these functions are (currently) slower than their dart counterparts, in large part due to the lack
of first class continuations in dart (or an optimised generator implementation). If you have any ideas about
a more efficient implementation of any of the functions, don't hesitate to file an issue or submit a pull
request.


### tuple ###

An implementation of fixed-length constable products of elements.

