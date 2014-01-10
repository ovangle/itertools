part of itertools;

/**
 * [:groupBy:] groups the items together by the value of a specified key
 * function (defaults to the identity function).
 *
 * Note that unlike python, which yields a new group every time the key
 * function changes, all values which match the key in the returned iterable
 * are returned in the [Grouping]s.
 *
 * The key of each of the returned [Grouping]s is the result of applying the key function
 * to all of the elements of the group.
 */
Iterable<Grouping> groupBy(Iterable iterable, { dynamic key(var k): _id }) =>
    _groupPairs(zip(iterable.map(key), iterable), new Set());


Iterable<Grouping> _groupPairs(Iterable<Tuple2> pairs, Set seenKeys) {
  var k;
  try {
    k = pairs.firstWhere((p) => !seenKeys.contains(p.$1)).$1;
  } on StateError {
    return const [];
  }
  seenKeys.add(k);
  var grpValues =
      pairs.where((pair) => pair.$1 == k)
           .map((pair) => pair.$2);
  var grp = new Grouping(k, grpValues);
  return yield(grp, () => _groupPairs(pairs, seenKeys));
}

class Grouping<T,U>
    extends Object with IterableMixin<U> {
  final T key;
  final Iterable<U> values;

  Grouping(this.key, this.values);

  Iterator<U> get iterator => values.iterator;

  String toString() => "{$key : $values}";
}