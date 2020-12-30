import 'package:flutter/material.dart';
import 'package:kbc_pos/models/generic/dashboard_item_model.dart';

class DashboardListItem extends StatelessWidget {
  final DashboardItemModel dashboardItem;
  final VoidCallback onTap;
  final double height, width;

  DashboardListItem({ @required this.dashboardItem, @required this.height,
    @required this.width, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 10.0,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(dashboardItem.img),
                  fit: BoxFit.contain,
                  width: 80,
                  height: 80,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  dashboardItem.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                    letterSpacing: 2.0,
                    color: Colors.redAccent,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    dashboardItem.subtitle,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 2.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
