import 'package:kbc_pos/models/objects/location.dart';
import 'package:kbc_pos/models/objects/member.dart';
import 'package:kbc_pos/models/objects/session.dart';

abstract class OrderInfoRepo{

  Future<List<Member>> getMembers();
  Future<List<Location>> getVenue();
  Future<List<Session>> getSession();
  Future<bool> insertOrderInfo();
}

class OrderInfoService extends OrderInfoRepo{

  @override
  Future<List<Member>> getMembers() {
    // TODO: implement getMembers
    throw UnimplementedError();
  }

  @override
  Future<List<Session>> getSession() {
    // TODO: implement getSession
    throw UnimplementedError();
  }

  @override
  Future<List<Location>> getVenue() {
    // TODO: implement getVenue
    throw UnimplementedError();
  }

  @override
  Future<bool> insertOrderInfo() {
    // TODO: implement insertOrderInfo
    throw UnimplementedError();
  }
}

