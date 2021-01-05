import 'dart:convert';

class Category{

  static final String categoryId = 'Id';
  static final String categoryName = 'Name';

  final String id, name;
  const Category({ this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> json)
  => Category(
    id: json[categoryId],
    name: json[categoryName]
  );

  Map<String, dynamic> toJson() => {
    categoryId : id,
    categoryName : name
  };

}

List<Category> categoryListFromJson(String str) =>List<Category>.from(json.decode(str)['Data'].map((x) => Category.fromJson(x)));
