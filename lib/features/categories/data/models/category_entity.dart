import 'package:isar/isar.dart';

part 'category_entity.g.dart';

@collection
class CategoryEntity {
  Id id = Isar.autoIncrement; // Isar auto-incrementing ID

  @Index(unique: true) // Ensure category names are unique
  late String name;

  CategoryEntity({
    required this.name,
  });
} 