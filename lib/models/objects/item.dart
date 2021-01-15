import 'dart:convert';

import 'package:equatable/equatable.dart';

class Item extends Equatable{

  static final String itemId = 'Id';
  static final String itemCategoryId = 'CategoryId';
  static final String itemName = 'Name';
  static final String itemPrice = 'Price';
  static final String itemQty = 'Quantity';

  final String id, categoryId, name, price;
  int quantity;
  Item({ this.id, this.categoryId, this.name, this.price, this.quantity});

  factory Item.fromJson(Map<String, dynamic> json)
  => Item(
    id : json[itemId],
    categoryId : json[itemCategoryId],
    name: json[itemName],
    price: json[itemPrice],
    quantity: 1,
  );

  Map<String, dynamic> toJson() => {
    itemId : id,
    itemCategoryId : categoryId,
    itemName : name,
    itemPrice : price,
    itemQty : quantity.toString()
  };

  @override
  // TODO: implement props
  List<Object> get props => [id, categoryId, name, price, quantity];


}

List<Item> itemListFromJson(String str) => List<Item>.from(json.decode(str)['Data'].map((x) => Item.fromJson(x)));