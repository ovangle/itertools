/**
 * A library which allows for the creation of lazy iterables in dart.
 */
library itertools.yield;

import 'dart:collection';

/**
 * Any function which takes no arguments and returns an iterable
 * can be used as a [:yield:] continuation
 */
typedef Iterable<T> Continue<T>();
Iterable _empty() => const [];

/**
 * [:yield:] takes a value and a function which accepts no arguments
 * and returns an iterable and returns a lazy iterable which includes
 * the inital value followed by the elements returned by the continuation.
 *
 * The continuation is expected to be a pure function.
 */
Iterable yield(var val, [Continue continuation = _empty]) => new _YieldIterable(val, continuation);

/**
 * [:yieldAll:] yields all values from the argument iterator in
 * turn, before calling the continuation.
 *
 * The continuation is expected t be a pure function.
 */
Iterable yieldAll(Iterable values, [Continue continuation = _empty]) =>
    new _YieldAllIterable(values, continuation);

abstract class _YieldIterableBase<T>
    extends Object with IterableMixin<T>
    implements Iterable<T> {
  final Continue<T> _continuation;

  Iterable<T> _cachedContinuationResult = null;
  Iterable<T> get _continuationResult {
    if (_cachedContinuationResult == null) {
      _cachedContinuationResult = _continuation();
    }
    return _cachedContinuationResult;
  }

  _YieldIterableBase(Continue<T> this._continuation);
}


abstract class _YieldIteratorBase<T> implements Iterator<T> {
  final _YieldIterableBase<T> _yieldIterable;

  _YieldIteratorBase(this._yieldIterable);
}

class _YieldIterable<T>
    extends _YieldIterableBase<T> {
  final T _first;
  _YieldIterable(T this._first, Continue<T> continuation) : super(continuation);

  //A yield iterable is never empty
  bool get isEmpty => false;
  bool get isNotEmpty => true;

  T get first => _first;

  Iterable<T> skip(int n) {
    if (n == 1)
      return _continuationResult;
    return super.skip(n);
  }

  Iterator<T> get iterator => new _YieldIterator<T>(_first, this);
}

class _YieldAllIterable<T>
extends _YieldIterableBase<T> {
  final Iterable<T> iterable;
  _YieldAllIterable(Iterable<T> this.iterable, Continue<T> continuation) : super(continuation);

  Iterator<T> get iterator => new _YieldAllIterator<T>(iterable.iterator, this);
}


class _YieldIterator<T> extends _YieldIteratorBase<T> {
  bool _onFirst = false;
  Iterator<T> _tailIterator = null;
  final T _first;


  _YieldIterator(T this._first, _YieldIterableBase<T> yieldIterable) : super(yieldIterable);

  T get current {
    if (!_onFirst) {
      return null;
    } else if (_tailIterator == null) {
      return _first;
    }
    return _tailIterator.current;
  }

  bool moveNext() {
    if (!_onFirst) {
      _onFirst = true;
      return _onFirst;
    }
    if (_tailIterator == null) {
      _tailIterator = _yieldIterable._continuationResult.iterator;
    }
    return _tailIterator.moveNext();
  }
}

class _YieldAllIterator<T> extends _YieldIteratorBase<T> {
  Iterator<T> _tailIterator = null;
  final Iterator<T> _iterator;

  _YieldAllIterator(Iterator<T> this._iterator, yieldIterable) : super(yieldIterable);

  T get current => _tailIterator != null ? _tailIterator.current : _iterator.current;

  bool moveNext() {
    if (!_iterator.moveNext()) {
      if (_tailIterator == null) {
        _tailIterator = _yieldIterable._continuationResult.iterator;
      }
      return _tailIterator.moveNext();
    }
    return true;
  }
}