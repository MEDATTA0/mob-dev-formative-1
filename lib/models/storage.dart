// This class is an abstract that posts, users, etc., will implement
class Entity {
  static int _nextId = 1;
  late int _id;
  late DateTime _createdAt;
  late DateTime _updatedAt;

  Entity() {
    _id = _nextId++;
    _createdAt = DateTime.now();
    _updatedAt = DateTime.now();
  }

  int getId() {
    return _id;
  }

  DateTime getCreatedAt() {
    return _createdAt;
  }

  DateTime getUpdatedAt() {
    return _updatedAt;
  }
}

abstract class Store<T extends Entity> {
  void loadDummy();
  T add(T data);
  T? findById(int id);
  void delete(int id);
  // T update({int id});
  List<T> findAll();
}
