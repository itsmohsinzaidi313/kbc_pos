import 'dart:convert';
import 'package:kbc_pos/models/generic/response_detail.dart';
import 'package:kbc_pos/models/objects/order.dart';
import 'package:kbc_pos/shared/config.dart';
import 'package:http/http.dart' as http;

abstract class OrderRepo{
  Future<List<Order>> getOrders();
  Future<ResponseDetail> payOrder(String orderKey);
  Future<ResponseDetail> deleteOrder(String orderKey);
}

class OrderService extends OrderRepo{

  @override
  Future<List<Order>> getOrders() async{
      List<Order> ordersList = [];
    try {
      String _url = '${Config.getOrderAPI}&userId=${Config.userId}';
      final response = await http.get(_url);
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        List<dynamic> list = map[Config.DATA];
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

  @override
  Future<ResponseDetail> deleteOrder(String orderKey) async{
    try{
      String _url = '${Config.deleteOrderAPI}&orderKey=$orderKey}';
      final response = await http.get(_url);
      Map<String, dynamic> responseM;
      if(response.statusCode == 200){
        print(response.body);
        responseM = json.decode(response.body);
        return ResponseDetail(status: responseM[Config.STATUS], message: responseM[Config.MESSAGE]);
      } else{
        return ResponseDetail(status: responseM[Config.STATUS], message: responseM[Config.MESSAGE]);
      }
    } catch(e){
      return ResponseDetail(status: false, message: e.toString());
      print(e.toString());
    }
  }

  @override
  Future<ResponseDetail> payOrder(String orderKey) async{
    try{
      String _url = '${Config.paymentOrderAPI}&orderKey=$orderKey}';
      final response = await http.get(_url);
      Map<String, dynamic> responseM;
      if(response.statusCode == 200){
        print(response.body);
        responseM = json.decode(response.body);
        return ResponseDetail(status: responseM[Config.STATUS], message: responseM[Config.MESSAGE]);
      } else{
        return ResponseDetail(status: responseM[Config.STATUS], message: responseM[Config.MESSAGE]);
      }
    } catch(e){
      return ResponseDetail(status: false, message: e.toString());
      print(e.toString());
    }
  }



}

