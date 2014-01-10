part of itertools;

Iterable<Tuple> zip(Iterable iter1, Iterable iter2, [Iterable iter3, Iterable iter4, Iterable iter5])
{
  if (iter3 == null) return Tuple2.zip(iter1, iter2);
  if (iter4 == null) return Tuple3.zip(iter1, iter2, iter3);
  if (iter5 == null) return Tuple4.zip(iter1, iter2, iter3, iter4);
  return Tuple5.zip(iter1, iter2, iter3, iter4, iter5);
}


//A sentinel value distinguishable from null
class _Sentinel { const _Sentinel(); }
const _SENTINEL = const _Sentinel();

abstract class Tuple {
  List get _items;

  const Tuple._();

  factory Tuple.fromValues(var $1, var $2, [var $3 = _SENTINEL, var $4 = _SENTINEL, var $5 = _SENTINEL]) {
    if ($3 == _SENTINEL) {
      return new Tuple2($1, $2);
    }
    if ($4 == _SENTINEL) {
      return new Tuple3($1, $2, $3);
    }
    if ($5 == _SENTINEL) {
      return new Tuple4($1, $2, $3, $4);
    }
    return new Tuple5($1, $2, $3, $4, $5);
  }

  bool operator ==(Object other) =>
      other is Tuple
      && other._items.length == _items.length
      && itertools.enumerate(_items).every((i) => i.$2 == other._items[i.$1]);

  int get hashCode => _items.fold(37, (h, i) => h * 37 + i.hashCode);

  String toString() => "<${_items.join(", ")}>";
}

class Tuple2<T1, T2> extends Tuple {
  static Iterable<Tuple2> zip(Iterable iter1, Iterable iter2) {
    if (iter1.isEmpty) return const [];
    if (iter2.isEmpty) return const [];
    return yield(new Tuple2(iter1.first, iter2.first), () => zip(iter1.skip(1), iter2.skip(1)));
  }

  final T1 $1;
  final T2 $2;

  const Tuple2(T1 this.$1, T2 this.$2) : super._();

  List get _items => [$1, $2];
}

class Tuple3<T1,T2,T3> extends Tuple {
  static Iterable<Tuple3> zip(Iterable iter1, Iterable iter2, Iterable iter3) {
    if (iter1.isEmpty) return const [];
    if (iter2.isEmpty) return const [];
    if (iter3.isEmpty) return const [];
    return yield(new Tuple3(iter1.first, iter2.first, iter3.first),
                 () => zip(iter1.skip(1), iter2.skip(1), iter3.skip(1)));
  }

  final T1 $1;
  final T2 $2;
  final T3 $3;

  const Tuple3(T1 this.$1, T2 this.$2, T3 this.$3) : super._();

  List get _items => [$1, $2, $3];
}


class Tuple4<T1,T2,T3, T4> extends Tuple {
  static Iterable<Tuple4> zip(Iterable iter1, Iterable iter2, Iterable iter3, Iterable iter4) {
    if (iter1.isEmpty) return const [];
    if (iter2.isEmpty) return const [];
    if (iter3.isEmpty) return const [];
    if (iter4.isEmpty) return const [];
    return yield(new Tuple4(iter1.first, iter2.first, iter3.first, iter4.first),
                 () => zip(iter1.skip(1), iter2.skip(1), iter3.skip(1), iter4.skip(1)));
  }


  final T1 $1;
  final T2 $2;
  final T3 $3;
  final T4 $4;

  const Tuple4(T1 this.$1, T2 this.$2, T3 this.$3, T4 this.$4) : super._();

  List get _items => [$1, $2, $3, $4];
}


class Tuple5<T1,T2,T3,T4,T5> extends Tuple {
  static Iterable<Tuple4> zip(Iterable iter1, Iterable iter2, Iterable iter3, Iterable iter4, Iterable iter5) {
    if (iter1.isEmpty) return const [];
    if (iter2.isEmpty) return const [];
    if (iter3.isEmpty) return const [];
    if (iter4.isEmpty) return const [];
    if (iter5.isEmpty) return const [];
    return yield(new Tuple5(iter1.first, iter2.first, iter3.first, iter4.first, iter5.first),
                 () => zip(iter1.skip(1), iter2.skip(1), iter3.skip(1), iter4.skip(1), iter5.skip(1)));
  }

  final T1 $1;
  final T2 $2;
  final T3 $3;
  final T4 $4;
  final T5 $5;

  const Tuple5(T1 this.$1, T2 this.$2, T3 this.$3, T4 this.$4, T5 this.$5) : super._();

  List get _items => [$1, $2, $3, $4, $5];
}

