// This class is an abstract that posts, users, etc., will implement
class Entity {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;

  Entity({this.id, this.createdAt, this.updatedAt});

  int getId() {
    return id ?? -1;
  }

  DateTime getCreatedAt() {
    return createdAt ?? DateTime.now();
  }

  DateTime getUpdatedAt() {
    return updatedAt ?? DateTime.now();
  }
}

abstract class Store<T extends Entity> {
  Future<void> loadDummy();
  Future<T> add(T data);
  Future<T?> findById(int id);
  Future<void> delete(int id);
  Future<List<T>> findAll();
}
