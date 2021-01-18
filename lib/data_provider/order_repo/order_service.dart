import 'package:kbc_pos/models/objects/item.dart';
import 'package:kbc_pos/models/objects/member.dart';
import 'package:kbc_pos/models/objects/order.dart';

abstract class OrderRepo{
  Future<List<Order>> getOrders();
}

class OrderService extends OrderRepo{

  @override
  Future<List<Order>> getOrders() async{
    List<Order> list;
    await Future.delayed(Duration(seconds: 1), (){
      list =  [
        Order(
            item: [
              Item(id: "1", quantity: 1, price: "100", categoryId: "1", name: "Item 01"),
              Item(id: "2", quantity: 1, price: "200", categoryId: "3", name: "Item 02"),
              Item(id: "3", quantity: 1, price: "300", categoryId: "2", name: "Item 03"),
            ],
            member: [
              Member(memberId: 1, memberName: "Member 1", memberNo: "123", memberBirthDate: "12/3/2020", memberElectDate: "12/1/2021", memberStatus: "A", memberType: "Type 1"),
              Member(memberId: 2, memberName: "Member 2", memberNo: "122", memberBirthDate: "12/1/2020", memberElectDate: "12/1/2021", memberStatus: "E", memberType: "Type 2"),
              Member(memberId: 3, memberName: "Member 3", memberNo: "111", memberBirthDate: "12/2/2020", memberElectDate: "12/1/2021", memberStatus: "T", memberType: "Type 3"),
            ],
            table: "1",
            waiter: "1",
            session: "1",
            venue: "1",
            slip: "1",
            orderNo: "1",
            cover: "1"
        ),
        Order(
            item: [
              Item(id: "1", quantity: 1, price: "100", categoryId: "1", name: "Item 01"),
              Item(id: "2", quantity: 1, price: "200", categoryId: "3", name: "Item 02"),
              Item(id: "3", quantity: 1, price: "300", categoryId: "2", name: "Item 03"),
            ],
            member: [
              Member(memberId: 1, memberName: "Member 1", memberNo: "123", memberBirthDate: "12/3/2020", memberElectDate: "12/1/2021", memberStatus: "A", memberType: "Type 1"),
              Member(memberId: 2, memberName: "Member 2", memberNo: "122", memberBirthDate: "12/1/2020", memberElectDate: "12/1/2021", memberStatus: "E", memberType: "Type 2"),
              Member(memberId: 3, memberName: "Member 3", memberNo: "111", memberBirthDate: "12/2/2020", memberElectDate: "12/1/2021", memberStatus: "T", memberType: "Type 3"),
            ],
            table: "2",
            waiter: "2",
            session: "2",
            venue: "2",
            slip: "2",
            orderNo: "2",
            cover: "2"
        ),
        Order(
            item: [
              Item(id: "1", quantity: 1, price: "100", categoryId: "1", name: "Item 01"),
              Item(id: "2", quantity: 1, price: "200", categoryId: "3", name: "Item 02"),
              Item(id: "3", quantity: 1, price: "300", categoryId: "2", name: "Item 03"),
            ],
            member: [
              Member(memberId: 1, memberName: "Member 1", memberNo: "123", memberBirthDate: "12/3/2020", memberElectDate: "12/1/2021", memberStatus: "A", memberType: "Type 1"),
              Member(memberId: 2, memberName: "Member 2", memberNo: "122", memberBirthDate: "12/1/2020", memberElectDate: "12/1/2021", memberStatus: "E", memberType: "Type 2"),
              Member(memberId: 3, memberName: "Member 3", memberNo: "111", memberBirthDate: "12/2/2020", memberElectDate: "12/1/2021", memberStatus: "T", memberType: "Type 3"),
            ],
            table: "3",
            waiter: "3",
            session: "3",
            venue: "3",
            slip: "3",
            orderNo: "3",
            cover: "3"
        )
      ];
    });
    return list;
  }

}

