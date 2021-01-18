import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kbc_pos/models/generic/response_detail.dart';
import 'package:kbc_pos/models/objects/category.dart';
import 'package:kbc_pos/models/objects/item.dart';
import 'package:kbc_pos/shared/config.dart';

abstract class PosRepo{

  Future<List<Category>> getCategories();
  Future<List<Item>> getItemsById({ @required String id});
  Future<ResponseDetail> sendOrder(Map<String, dynamic> map);
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

  @override
  Future<ResponseDetail> sendOrder(Map<String, dynamic> map) async{
    // Map<String, dynamic> mMap = {'' : map};
    String mMapJson = jsonEncode(map);
    String mMapJsonReplace = mMapJson.replaceAll('"', '\\"');
    print('JSON ENCODE: $mMapJsonReplace');
    // print('JSON DECODE: $jsonDecode($mMapJson)');
    String url = Config.sendOrderAPI;
    final response = await http.post(url,
        headers: {'Content-type' : 'application/json'},
      body: '"$mMapJsonReplace"',
    );
    // print(response.body);
    // Map responseMap;
    // responseMap = jsonDecode(response.body);
    // responseMap.forEach((key, value) {print('$key : $value');});
    //
    if(response.statusCode == 200){
      print(response.body);
      return ResponseDetail(status: true, message: response.reasonPhrase);
    }
    return ResponseDetail(status: false, message: response.reasonPhrase);

  }

  static Future<List<Item>> searchingItem({String text}) async{
    List<Item> list;
    try {
      String url = '${Config.searchItemAPI}$text';
      final response = await http.get(url);
      print(response.body);
      if(response.statusCode == 200){
        list = itemListFromJson(jsonDecode(response.body));
      }else{
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
    return list;
  }

}