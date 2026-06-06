import 'package:assignment1/models/entities/entity.dart';

abstract class Store<T extends Entity> {
  Future<void> loadDummy();
  Future<T> add(T data);
  Future<T?> findById(int id);
  Future<void> delete(int id);
  Future<List<T>> findAll();
}
