import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kbc_pos/shared/app_theme.dart';
import 'package:kbc_pos/shared/config.dart';


class OrderScreen extends StatefulWidget {

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  /// int orderType;
  ///1 for dine-in
  ///2 for takeaway  ///3 for delivery


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
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: RaisedButton.icon(
                      onPressed: () {
                          ///set orderType to 1
                      },
                      color: AppTheme.listTextColor,
                      icon: Icon(
                        Icons.local_dining,
                      ),
                      label: Text('Dine-In'.toUpperCase()),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: RaisedButton.icon(
                      onPressed: () {
                          ///set orderType to 2
                      },
                      color: AppTheme.listTextColor,
                      icon: Icon(
                        Icons.directions_walk,
                      ),
                      label: Text('Takeaway'.toUpperCase()),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: RaisedButton.icon(
                      onPressed: () {
                          ///set orderType to 3
                      },
                      color: AppTheme.listTextColor,
                      icon: Icon(
                        Icons.directions_bike,
                      ),
                      label: Text('Delivery'.toUpperCase()),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                flex: 1,
                child: FutureBuilder(
                    future: getOrdersList(/*orderType*/null),
                    initialData: Container(
                      child: SpinKitRing(
                        color: Colors.yellow[800],
                      ),
                    ),
                    builder: (context, snapshot) => snapshot.data)),
          ],
        ),
      ),
    );
  }

  Future<Widget> getOrdersList(int orderType) async {
    Widget widget;
    switch (orderType) {
      case 1:
      ///get dine-in list
        break;
      case 2:
      ///get takeaway list
        break;
      case 3:
      ///get delivery list
        break;
      default:
        break;
    }
    return widget;
  }

  Future onOrderCancelled() async {
    ///function for order cancelling
  }
}
