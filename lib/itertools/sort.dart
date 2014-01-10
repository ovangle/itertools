part of itertools;

/**
 * Sorts the iterable, using a lazy merge sort.
 */
Iterable sort(Iterable iterable, [Comparator comparator = Comparable.compare]) {
  if (iterable.isEmpty) return [];
  return _mergePairs(iterable.map((i) => [i]), comparator).first;
}

Iterable _mergePairs(Iterable pairs, Comparator comparator) {
  var firstPairs = pairs.take(2);
  //If we have 0 or 1 pairs, they're merged.
  if (firstPairs.length < 2) {
    return firstPairs;
  }
  return _mergePairs(
      yield(_merge(firstPairs.first, firstPairs.last, comparator),
               () => _mergePairs(pairs.skip(2), comparator)),
      comparator);
}

Iterable _merge(Iterable m1, Iterable m2, Comparator comparator) {
  if (m1.isEmpty) return m2;
  if (m2.isEmpty) return m1;
  var f1 = m1.first, f2 = m2.first;
  var cmp = comparator(f1, f2);
  if (cmp > 0) {
    return yield(f2, () => _merge(m1, m2.skip(1), comparator));
  } else {
    return yield(f1, () => _merge(m1.skip(1), m2, comparator));
  }
}
