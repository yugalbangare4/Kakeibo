class CategoryModel {
  final int? id;
  final String name;
  final String iconName;
  final int colorIndex;
  final int sortOrder;
  final bool isDefault;
  final DateTime createdAt;

  CategoryModel({
    this.id,
    required this.name,
    required this.iconName,
    required this.colorIndex,
    required this.sortOrder,
    required this.isDefault,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'icon_name': iconName,
      'color_index': colorIndex,
      'sort_order': sortOrder,
      'is_default': isDefault ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      iconName: map['icon_name'] as String,
      colorIndex: map['color_index'] as int,
      sortOrder: map['sort_order'] as int,
      isDefault: (map['is_default'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
