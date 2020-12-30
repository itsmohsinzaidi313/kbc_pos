import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:kbc_pos/models/generic/dashboard_item_model.dart';
import 'package:kbc_pos/screens/list_template/dashboard_list_items.dart';


class DashboardScreen extends StatefulWidget {

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Dashboard'),
            Text('Shift#: '),
          ],
        ),
        centerTitle: true,
      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text('Tap again to exit the screen'),
        ),
        child: GridView.builder(
          itemCount: DashboardItemModel().dashboardItemModel.length,
          shrinkWrap: true,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemBuilder: (context, position) {
            return DashboardListItem(
              dashboardItem : DashboardItemModel().dashboardItemModel[position],
               height : 250.0,
              width : 250.0,
                  onTap : () {
                print(DashboardItemModel().dashboardItemModel[position].name);
              },
            );
          },
        ),
      ),
    );
  }
}
