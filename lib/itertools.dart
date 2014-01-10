
/**
 * Useful utility functions for dealing with iterators, which have not been exposed
 * via the `'dart:collection`' interface.
 */
library itertools;

import 'dart:collection';

import 'yield.dart';
import 'tuple.dart';

export 'tuple.dart';

part 'itertools/zip.dart';
part 'itertools/grouping.dart';
part 'itertools/sort.dart';
part 'itertools/join.dart';

//An id function
_id(x) => x;


/**
 * The default selector for join, groupBy, zip, etc. methods is just a list containing both the items.
 */
Tuple _defaultSelector(var innerElement, var outerElement) =>
    new Tuple.fromValues(innerElement, outerElement);

/**
 * Returns a infinite iterable obtained by concatenating the argument, repeated indefinitely.
 *
 * eg.
 *      cycle([1,2,3,4]) == (1,2,3,4,1,2,3,4,1,2,3,4...)
 */
Iterable cycle(Iterable value) => concat(repeat(value));
/**
 * Returns an infinite iterable obtained by repeating the argument indefinitely.
 * eg.
 *      repeat(1) == (1,1,1...)
 */
Iterable repeat(value) => count(0).map((_) => value);

/**
 * Returns an infinite list of successive integers, starting from `0` in
 * increments of [step].
 */
Iterable<int> count([int start=0, int step=1]) {
  if (step == 0)
    throw new ArgumentError("Step cannot be 0");
  return yield(start, () => count(start + step, step));
}

Iterable<int> range(int start, [int stop, int step]) {
  if (step == 0)
    throw new ArgumentError("step cannot be 0");
  var len;
  if (stop != null) {
    len = (stop - start) / step;
  } else {
    len = start / step;
    start = 0;
  }
  return new Iterable.generate(len, (i) => start + i * step);
}
/**
 * Returns an [Iterable]
 */
Iterable<Tuple2<int,dynamic>> enumerate(Iterable iterable) {
  return zip(count(), iterable);
}

/**
 * Concatenates a [Iterable] of [Iterable]s into a single iterable.
 *
 * Equivalent to
 *      iterables.expand((i) => i);
 */
Iterable concat(Iterable<Iterable> iterables) => iterables.expand((i) => i);

/**
 * Returns the infinte list obtained by repeatedly applying the function [:f:] to an initial value
 *    [x, f(x), f(f(x)), f(f(f(x))), ...]
 * This function is obviously very susceptible to stack overflow.
 */
Iterable induction(var x, dynamic f(var x)) => yield(x, () => induction(x, f).map(f));

/**
 * Returns the reverse of the given iterable.
 */
Iterable reverse(Iterable iterable) {
  if (iterable.isEmpty) return [];
  return yield(iterable.last, () => reverse(iterable.take(iterable.length - 1)));
}

Iterable slice(Iterable iterable, int start, [int stop, int step=1]) {
  if (step <= 0) {
    throw new ArgumentError("Step cannot be 0");
  } else if (start >= stop || iterable.isEmpty) {
    return const[];
  } else if (start == 0) {
    return yield(iterable.first, () => slice(iterable.skip(step), 0, stop - step, step));
  } else {
    return slice(iterable.skip(start), 0, stop - start, step);
  }
}
