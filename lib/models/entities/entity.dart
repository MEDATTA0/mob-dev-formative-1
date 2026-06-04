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
