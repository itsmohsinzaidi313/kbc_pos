import 'package:kbc_pos/models/objects/location.dart';
import 'package:kbc_pos/models/objects/member.dart';
import 'package:kbc_pos/models/objects/session.dart';

abstract class OrderInfoRepo{

  Future<List<Member>> getMembers();
  Future<List<Location>> getLocation();
  Future<List<Session>> getSession();
  Future<bool> insertOrderInfo();
}

class OrderInfoService extends OrderInfoRepo{

  @override
  Future<List<Member>> getMembers() async{
    List<Member> list;
    await Future.delayed(Duration(seconds: 1), (){
      list = [
        Member(memberId: 1, memberNo: '1220', memberType: 'PL', memberStatus: 'E', memberName: 'MR. C. G. KHARAS'),
        Member(memberId: 1, memberNo: '1856', memberType: 'PO', memberStatus: 'R', memberName: 'MR. USMAN AMINUDDIN'),
        Member(memberId: 1, memberNo: '2651', memberType: 'PE', memberStatus: 'E', memberName: 'MR. SALEENM A. THARIANI'),
      ];
    });
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
  Future<bool> insertOrderInfo() {
    // TODO: implement insertOrderInfo
    throw UnimplementedError();
  }
}

