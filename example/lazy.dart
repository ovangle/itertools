
import '../lib/yield.dart';
//import 'package:lazy/itertools.dart';

void main() {

  Tree<int> root = new Tree<int>(8)
    ..addChild(new Tree<int>(3)
          ..addChild(new Tree<int>(1))
          ..addChild(new Tree<int>(6)
                ..addChild(new Tree<int>(4))
                ..addChild(new Tree<int>(7))))
    ..addChild(new Tree<int>(10)
        ..addChild(new Tree<int>(14)
            ..addChild(new Tree<int>(13))));
  print(root.preOrderTraversal().map(
      (s) => s.toString()));
}

class Tree<T> {
  List<Tree<T>> children = new List<Tree<T>>();

  T nodeValue;

  Tree(T this.nodeValue);

  void addChild(Tree<T> child) {
    children.add(child);
  }

  Iterable<Tree<T>> preOrderTraversal() {
    return yield(this, () => children.expand((c) => c.preOrderTraversal()));
  }

  String toString() => nodeValue.toString();
}
