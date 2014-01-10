part of itertools;

/**
 * [:groupJoin:] is the equivalent of the C# Enumerable.GroupJoin.
 *
 * It takes two iterables, the [:innerIterable:] and the [:outerIterable:].
 * It returns an [Iterable] of [Grouping]s, where each group returned consists
 * of all elements of the outer iterable are
 *
 * Note that unlike [:groupBy:], the [:key:] of each of the returned groups
 * is the element of the innerIterable which generated the group, rather
 * than the result of applying the key function to that element.
 */
Iterable<Grouping> groupJoin(Iterable innerIterable,
                             Iterable outerIterable,
                             { dynamic innerKey(var key) : _id,
                               dynamic outerKey(var key) : _id
                             }) {
  var innerPairs = zip(innerIterable.map(innerKey), innerIterable);
  var outerPairs = zip(outerIterable.map(outerKey), outerIterable);
  return _groupJoinPairs(innerPairs, outerPairs);
}


Iterable<dynamic> innerJoin(Iterable innerIterable,
                             Iterable outerIterable,
                             { dynamic innerKey(var key) : _id,
                               dynamic outerKey(var key) : _id,
                               dynamic selector(var innerElement, var outerElement) : _defaultSelector
                             }) {
  return _selectGroups(
      groupJoin(innerIterable, outerIterable, innerKey: innerKey, outerKey: outerKey),
      selector,
      false);
}


Iterable<dynamic> leftOuterJoin(Iterable innerIterable,
                                Iterable outerIterable,
                                { dynamic innerKey(var key) : _id,
                                  dynamic outerKey(var key) : _id,
                                  dynamic selector(var innerElement, var outerElement) : _defaultSelector
                                }) {
  return _selectGroups(
      groupJoin(innerIterable, outerIterable, innerKey: innerKey, outerKey: outerKey),
      selector,
      true);
}


Iterable<Grouping> _groupJoinPairs(Iterable<Tuple2> innerPairs,
                                   Iterable<Tuple2> outerPairs) {
  if (innerPairs.isEmpty) return const [];
  var keyPair = innerPairs.first;
  var key = keyPair.$1;
  var grpValues = outerPairs.where((p) => p.$1 == key).map((p) => p.$2);
  return yield(new Grouping(keyPair.$2, grpValues),
               () => _groupJoinPairs(innerPairs.skip(1), outerPairs));
}

Iterable<dynamic> _selectGroups(Iterable<Grouping> groups,
                                dynamic selector(var innerElement, var outerElement),
                                bool isOuterJoin) {
  if (groups.isEmpty) return [];
  var fstGroup = groups.first;
  if (fstGroup.values.isEmpty && isOuterJoin) {
    //In a left outer join, we want to still yield a value for the group
    //even if there are no values.
    return yield(
        selector(fstGroup.key, null),
        () => _selectGroups(groups.skip(1), selector, isOuterJoin));
  }
  return yieldAll(
      fstGroup.values.map((v) => selector(fstGroup.key, v)),
      () => _selectGroups(groups.skip(1), selector, isOuterJoin));
}