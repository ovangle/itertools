library itertools.test;

import 'package:unittest/unittest.dart';

import '../lib/itertools.dart';
import '../lib/tuple.dart';

void defineTests() {
  group ("basic iteratables:", () {
    testRepeat();
    testCycle();
    testCount();
    testInduction();
    testReverse();
    testEnumerate();
    testSlice();
    testSort();
  });
}

testRepeat() {
  test("Repeat a value", () {
    expect(repeat(1).take(5), [1,1,1,1,1]);
  });
}

testCycle() {
  test("Cycle a list", () {
    expect(cycle([1,2,3,4]).take(20), [1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4]);
  });
}

testCount() {
  test("Count from 0 to 100", () {
    expect(count().take(100), new Iterable.generate(100, (x) => x));
  });
  test("Count from 5 to 25 in steps of 2", () {
    expect(count(5,2).take(11), [5,7,9,11,13,15,17,19,21,23,25]);
  });
}

testInduction() {
  test("Induction of (x) => (x * 2)", () {
    expect(induction(2, (x) => x * 2).take(5), [2, 4, 8, 16, 32]);
  });
}

testEnumerate() {
  test("Enumeration of alphabet", () {
    expect(enumerate([2,4,6,8,10]),
           [ new Tuple2(0, 2),
             new Tuple2(1, 4),
             new Tuple2(2, 6),
             new Tuple2(3, 8),
             new Tuple2(4, 10)
           ]);

  });
}

testReverse() {
  test("Reverse a list", () {
    expect(reverse([1,2,3,4,5]), [5,4,3,2,1]);
  });
}

testSlice() {
  var li = [0,1,2,3,4,5,6,7,8,9];
  group("slice:", () {
    test("li[0:2]", () {
      expect(slice(li, 0, 2), [0,1]);
    });
    test("li[0:4:2]", () {
      expect(slice(li, 0, 4, 2), [0,2]);
    });
  });
}

testSort() {
  test("Sort a list", () {
    expect(sort([1,4,2,3,6]), [1,2,3,4,6]);
  });
  test("Sort a list high to low", () {
    expect(sort([1,4,2,3,6], (a,b) => -Comparable.compare(a,b)), [6,4,3,2,1]);
  });
  test("Sort a long list", () {
    //Not really long. Optimisation necessary.
    expect(sort([1,4,2,6,3,75,52,8,99,3,2,3,5,53,2,345,6,74,22,34,56,342,34343,444]),
        [1,2,2,2,3,3,3,4,5,6,6,8,22,34,52,53,56,74,75,99,342,345,444,34343]);
  });
}

testGroupBy() {
  group("Group by", () {
    test("default selector", () {
      var li = [[1,2], [1,3], [2,3], [4,5]];
      expect(groupBy(li, key: (x) => x[0]),
            [ new Grouping(1,[[1,2],[1,3]]),
              new Grouping(2,[[2,3]]),
              new Grouping(4, [[4,5]])
            ]);
    });
  });
}