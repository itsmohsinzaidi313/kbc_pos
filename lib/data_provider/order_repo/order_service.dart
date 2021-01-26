import 'dart:convert';

import 'package:kbc_pos/models/objects/item.dart';
import 'package:kbc_pos/models/objects/member.dart';
import 'package:kbc_pos/models/objects/order.dart';
import 'package:kbc_pos/shared/config.dart';
import 'package:http/http.dart' as http;

abstract class OrderRepo{
  Future<List<Order>> getOrders();
}

class OrderService extends OrderRepo{

  @override
  Future<List<Order>> getOrders() async{
      List<Order> ordersList = [];
    try {
      // String _url = '${Config.getOrderAPI}&userId=${Config.userId}';
      String _url = '${Config.getOrderAPI}&userId=238';
      final response = await http.get(_url);
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        List<dynamic> list = map['Data'];
        list.forEach((element) {
          ordersList.add(Order.fromJson(element));
        });
      } else {
        print(response.body);
        print(response.reasonPhrase);
      }
    }
    catch(e) {
      print(e);
    }
      return ordersList;
  }

}

