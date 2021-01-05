import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kbc_pos/models/objects/category.dart';
import 'package:kbc_pos/models/objects/item.dart';
import 'package:kbc_pos/shared/config.dart';

abstract class PosRepo{

  Future<List<Category>> getCategories();
  Future<List<Item>> getItemsById({ @required String id});
}

class PosService extends PosRepo{

  @override
  Future<List<Category>> getCategories() async{
    List<Category> _categories;
    final response = await http.get(Config.getCategoryAPI);
    Map<String, dynamic> decodedJson;
    if(response.statusCode == 200){
      String decodedJson = jsonDecode(response.body);
      _categories = categoryListFromJson(decodedJson);
    } else{
      throw Exception(decodedJson['Message']);
    }
    return _categories;
  }


  @override
  Future<List<Item>> getItemsById({String id}) async{
    List<Item> _items;
    final response = await http.get('${Config.getItemsAPI}$id');
    Map<String, dynamic> decodedJson;
    if(response.statusCode == 200){
      String decodedJson = jsonDecode(response.body);
      _items = itemListFromJson(decodedJson);
    } else{
      throw Exception(decodedJson['Message']);
    }
    return _items;
  }


}