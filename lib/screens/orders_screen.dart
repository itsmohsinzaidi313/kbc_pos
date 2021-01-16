import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kbc_pos/bloc/order_bloc/order_bloc.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        key: _key,
        appBar: AppTheme.appBarNormal(
            appBarTitle: 'New Order',
            appBarBgColor: AppTheme.appBarColor,
            appBarElevation: 0.0,
            context: context),
        body: Container(
          height: Config.getDeviceHeight(context),
          width: Config.getDeviceWidth(context),
          child: BlocBuilder<OrderBloc, MyOrderStates>(
            builder: (context, state) {
              if (state is MyOrderStateList) {
                return ListView.builder(
                  key: _key,
                  scrollDirection: Axis.vertical,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.order.length,
                  itemBuilder: (context, index) {
                    return orderListItem(order: state.order[index]);
                  },
                );
              }
              else if (state is MyOrderStatesError){

              }
              return CustomCircularProgressIndication();
            },
          ),
        ));
  }

  Widget orderListItem({ @required Order order}){
    return ExpansionTile(title: Text(''));
  }
}
