import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kbc_pos/models/generic/response_detail.dart';
import 'package:http/http.dart' as http;
import 'package:kbc_pos/shared/config.dart';

abstract class LoginRepo {
  Future<ResponseDetail> authenticateUser({@required String username, String password});
}

class LoginService extends LoginRepo {

  @override
  Future<ResponseDetail> authenticateUser({String username, String password}) async{
    ResponseDetail responseDetail;
    Config().setLoginUserAPI(username, password);
    String _url = Config().getLoginUserAPI();
    final response = await http.get(_url).timeout(Duration(seconds: 5), onTimeout: (){
      throw Exception('**Time Out**.. Something went wrong!');
    });
    dynamic js;
    if(response.statusCode == 200){
      js = json.decode(jsonDecode(response.body));
      responseDetail = ResponseDetail.fromJson(js);
    } else{
      throw Exception(js['Message']);
    }
    return responseDetail;
  }

}
