import 'unsubscription_builder.dart';

class Unsubscribe implements UnsubscribeAbstract {
  final bool Function() callback;

  Unsubscribe(this.callback);

  @override
  bool unsubscribe() => callback();
}

class Subscription<T> {
  Map<int, Function(T data)> _idMapcallback = {};
  @override
  Subscription<T> next(T data) {
    _idMapcallback.forEach((_, callback) => callback(data));

    return this;
  }

  Unsubscribe subscribe(Function(T data) callback) {
    int id = DateTime.now().microsecondsSinceEpoch;
    _idMapcallback[id] = callback;
    return Unsubscribe(() {
      if (_idMapcallback[id] != null) {
        _idMapcallback.remove(id);
        return true;
      }
      return false;
    });
  }
}

class SubscriptionBuilder {
  static Subscription<T> builder<T>() {
    return Subscription<T>();
  }
}

class UnsubscribeCollect implements UnsubscribeCollectAbstract {
  final List<UnsubscribeAbstract> _unsubscribeList;

  UnsubscribeCollect(List<UnsubscribeAbstract> unsubscribeList)
      : _unsubscribeList = unsubscribeList;

  @override
  void unsubscribe() {
    for (var element in _unsubscribeList) {
      element.unsubscribe();
    }
  }

  @override
  void add(UnsubscribeAbstract unsubscribeAbstract) {
    _unsubscribeList.add(unsubscribeAbstract);
  }

  @override
  void addAll(Iterable<UnsubscribeAbstract> unsubscribeAbstract) {
    _unsubscribeList.addAll(unsubscribeAbstract);
  }
}