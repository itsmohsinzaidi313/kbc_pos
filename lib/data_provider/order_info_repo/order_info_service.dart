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
}

class OrderInfoService extends OrderInfoRepo{

  @override
  Future<List<Member>> getMembers(String query) async{
    List<Member> list;
    try {
      String url = '${Config.searchMembersAPI}$query';
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
    try{
      String url = Config.getSessionsAPI;
      final response = await http.get(url);
      if(response.statusCode == 200){
        list = sessionListFromJson(jsonDecode(response.body));
      } else {
        print(response.reasonPhrase);
        throw Exception(response.reasonPhrase);
      }
    }catch(e){
      print(e);
    }
    return list;
  }

  @override
  Future<List<Location>> getLocation() async{
    List<Location> list;
    try{
      String url = Config.getLocationsAPI;
      final response = await http.get(url);
      if(response.statusCode == 200){
        list = locationListFromJson(jsonDecode(response.body));
      } else {
        print(response.reasonPhrase);
        throw Exception(response.reasonPhrase);
      }
    }catch(e){
      print(e);
    }
    return list;
  }

  static Future<List<Member>> searchingMember({String text}) async{
    List<Member> list;
    try {
      String url = '${Config.searchMembersAPI}$text';
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
}

