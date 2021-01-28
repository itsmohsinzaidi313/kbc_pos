import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kbc_pos/bloc/order_bloc/order_bloc.dart';
import 'package:kbc_pos/bloc/order_bloc/order_event.dart';
import 'package:kbc_pos/bloc/order_bloc/order_states.dart';
import 'package:kbc_pos/models/objects/order.dart';
import 'package:kbc_pos/screens/custom_widget_classes/custom_circular_progress_indicator.dart';
import 'package:kbc_pos/shared/app_theme.dart';
import 'package:kbc_pos/shared/config.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<OrderBloc>().add(FetchingOrdersList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppTheme.appBarNormal(
          appBarTitle: 'New Order',
          appBarBgColor: AppTheme.appBarColor,
          appBarElevation: 0.0,
          context: context,
        ),
        body: Container(
          height: Config.getDeviceHeight(context),
          width: Config.getDeviceWidth(context),
          child: Column(
            children: [
              BlocConsumer<OrderBloc, MyOrderStates>(
                listener: (context, state){
                  if (state is OrderPaymentSuccessfully){
                    AppTheme.showAlertDialogOK(context, title: 'Order Payment', message: 'Order Payment Done Successfully',
                        onOK: () => Navigator.pop(context));
                  } else if (state is OrderDeletedSuccessfully){
                    AppTheme.showAlertDialogOK(context, title: 'Delete Order', message: 'Order Deleted Successfully',
                        onOK: () => Navigator.pop(context));
                  }
                },
                builder: (context, state) {
                  if (state is MyOrderStateList) {
                    return getOrdersList(order: state.order);
                  } else if (state is MyOrderStatesError) {
                    return Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          state.error,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  }
                  return CustomCircularProgressIndication();
                },
              ),
            ],
          ),
        ));
  }

  Widget orderListItem({@required Order order}) {
    return ExpansionTile(
      title: Text(
        order.member.first.memberName,
        style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
      ),
      leading: Text(order.orderNo.toString()),
      trailing: Icon(Icons.arrow_drop_down),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListView.builder(
              itemCount: order.member.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(order.member[index].memberNo),
                  ),
                  title: Text(
                    order.member[index].memberName,
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit_rounded,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/orderInfoScreen');
                    Config.isEditing = 1;
                    Config.selectedOrder = order;
                    print(order.orderKey);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.monetization_on_outlined,
                    color: Colors.green,
                  ),
                  onPressed: () async {
                    AppTheme.showAlertDialogYN(context,
                        title: 'Order Payment',
                        message: 'Are You Sure?',
                        onNo: () => Navigator.pop(context),
                        onYes: () {
                          context
                              .read<OrderBloc>()
                              .add(PaymentOrder(orderKey: order.orderKey));
                          Navigator.pop(context);
                        });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_rounded,
                    color: Colors.redAccent,
                  ),
                  onPressed: () async {
                    AppTheme.showAlertDialogYN(context,
                        title: 'Delete Order',
                        message: 'Are You Sure?',
                        onNo: () => Navigator.pop(context),
                        onYes: () {
                          context
                              .read<OrderBloc>()
                              .add(DeleteOrder(orderKey: order.orderKey));
                          Navigator.pop(context);
                        });
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget getOrdersList({ List<Order> order}){
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: order.length,
          itemBuilder: (context, index) {
            return orderListItem(order: order[index]);
          },
        ),
      ),
    );
  }
}
