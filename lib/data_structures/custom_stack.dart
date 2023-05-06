class MyStack<E> {
  final _list = <E>[];

  void push(E value) => _list.add(value);

  void pushEnd(E value) => _list.insert(_list.length, value);

  E pop() => _list.removeLast();

  E get peek => _list.last;

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;
  int get getSize => _list.length;
  List<E> get toList => _list;

  void insertAt(int index, E element) {
    if (index < 0 || index > 4) {
      return;
    }

    _list.insert(index, element);
    _list.removeLast();
  }

  E getAt(int index) {
    return _list[index];
  }

  @override
  String toString() => _list.toString();
}
