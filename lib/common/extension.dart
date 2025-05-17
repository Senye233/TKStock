extension ListExt<E> on List<E> {
  E? safeValue(int i) => (i >= 0 && i < length) ? this[i] : null;

  List<T> mapNotNull<T>(T? Function(E e) f) {
    List<T> res = [];
    for (var item in this) {
      final t = f(item);
      if (t == null) continue;
      res.add(t);
    }
    return res;
  }

  bool containFilter(bool Function(E e) filter) {
    for (var item in this) {
      if (filter(item)) {
        return true;
      }
    }
    return false;
  }
}