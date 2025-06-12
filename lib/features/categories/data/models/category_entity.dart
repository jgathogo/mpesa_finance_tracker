import 'package:isar/isar.dart';

part 'category_entity.g.dart';

@collection
class CategoryEntity {
  Id id;
  @Index(unique: true) // Ensure category names are unique
  late String name;

  CategoryEntity({
    this.id = Isar.autoIncrement,
    required this.name,
  });
} 