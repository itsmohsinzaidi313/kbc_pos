import 'dart:convert';

class Item{

  static final String itemId = 'Id';
  static final String itemCategoryId = 'CategoryId';
  static final String itemName = 'Name';
  static final String itemPrice = 'Price';

  final String id, categoryId, name, price;
  const Item({ this.id, this.categoryId, this.name, this.price});

  factory Item.fromJson(Map<String, dynamic> json)
  => Item(
    id : json[itemId],
    categoryId : json[itemCategoryId],
    name: json[itemName],
    price: json[itemPrice]
  );

  Map<String, dynamic> toJson() => {
    itemId : id,
    itemCategoryId : categoryId,
    itemName : name,
    itemPrice : price
  };

}

List<Item> itemListFromJson(String str) => List<Item>.from(json.decode(str)['Data'].map((x) => Item.fromJson(x)));