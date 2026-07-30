import 'package:kakeibo/features/categories/data/models/category_model.dart';

class Category {
  final int? id;
  final String name;
  final String iconName;
  final int colorIndex;
  final int sortOrder;
  final bool isDefault;
  final DateTime createdAt;

  Category({
    this.id,
    required this.name,
    required this.iconName,
    required this.colorIndex,
    required this.sortOrder,
    this.isDefault = false,
    required this.createdAt,
  });

  factory Category.fromModel(CategoryModel model) {
    return Category(
      id: model.id,
      name: model.name,
      iconName: model.iconName,
      colorIndex: model.colorIndex,
      sortOrder: model.sortOrder,
      isDefault: model.isDefault,
      createdAt: model.createdAt,
    );
  }

  CategoryModel toModel() {
    return CategoryModel(
      id: id,
      name: name,
      iconName: iconName,
      colorIndex: colorIndex,
      sortOrder: sortOrder,
      isDefault: isDefault,
      createdAt: createdAt,
    );
  }


  Category copyWith({
    int? id,
    String? name,
    String? iconName,
    int? colorIndex,
    int? sortOrder,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      colorIndex: colorIndex ?? this.colorIndex,
      sortOrder: sortOrder ?? this.sortOrder,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
