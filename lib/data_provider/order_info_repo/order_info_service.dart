import 'dart:convert';

import 'package:kbc_pos/models/objects/location.dart';
import 'package:kbc_pos/models/objects/member.dart';
import 'package:kbc_pos/models/objects/session.dart';
import 'package:http/http.dart' as http;
import 'package:kbc_pos/shared/config.dart';

abstract class OrderInfoRepo{

  Future<List<Member>> getMembers(String query);
  Future<List<Location>> getLocation();
  Future<List<Session>> getSession();
  Future<bool> insertOrderInfo();
}

class OrderInfoService extends OrderInfoRepo{

  @override
  Future<List<Member>> getMembers(String query) async{
      List<Member> list;
    try {
      String url = '${Config.getMembersAPI}$query';
      final response = await http.get(url);
      print(response.body);
      if(response.statusCode == 200){
            list = memberListFromJson(jsonDecode(response.body));
          }else{
            throw Exception(response.reasonPhrase);
          }
    } catch (e) {
      print(e);
    }
    return list;
  }

  @override
  Future<List<Session>> getSession() async{
    List<Session> list;
    await Future.delayed(Duration(seconds: 1), (){
      list = [
       Session(sessionId: 1, sessionName: 'Lunch', sessionApplyDiscount: 1),
       Session(sessionId: 1, sessionName: 'Parcel Lunch', sessionApplyDiscount: 0),
       Session(sessionId: 1, sessionName: 'Dinner', sessionApplyDiscount: 1),
      ];
    });
    return list;
  }

  @override
  Future<List<Location>> getLocation() async{
    List<Location> list;
    await Future.delayed(Duration(seconds: 1), (){
      list = [
        Location(locationId: 1, locationCode: '01', locationName: 'Harbour View Hall'),
        Location(locationId: 2, locationCode: '02', locationName: 'Garden View Hall'),
        Location(locationId: 3, locationCode: '03', locationName: 'Garden (S/H)'),
        Location(locationId: 4, locationCode: '04', locationName: 'Lower Deck'),
      ];
    });
    return list;
  }

  @override
  Future<bool> insertOrderInfo() async{
    bool isInserted = false;
    await Future.delayed(Duration(seconds: 1), (){
      isInserted = true;
    });
    return isInserted;
  }
}

