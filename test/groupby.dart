library itertools.groupby.test;

import 'package:unittest/unittest.dart';
import '../lib/itertools.dart';

void defineTests() {
  group("groupby iterables:", () {
    testGroupBy();
  });
}

void testGroupBy() {
  test("Group by default key", () {
    expect(groupBy([1,2,2,4,2,6,6]),
           [ new Grouping(1, [1]),
             new Grouping(2, [2,2,2]),
             new Grouping(4, [4]),
             new Grouping(6, [6,6])
           ]);
  });
  test("Group by with key func", () {
    expect(
        groupBy(["hello", "world", "how", "are", "you", "today"],
                key: (x) => x.length),
        unorderedEquals(
            [ new Grouping(5, ["hello", "world", "today"]),
              new Grouping(3, ["how", "are", "you"])
            ]));
  });
}