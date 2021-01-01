import 'package:flutter/material.dart';
import 'package:kbc_pos/models/generic/dashboard_item_model.dart';
import 'package:kbc_pos/shared/config.dart';

class DashboardListItem extends StatelessWidget {
  final DashboardItemModel dashboardItem;
  final VoidCallback onTap;

  DashboardListItem({ @required this.dashboardItem, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  width: Config.getDeviceWidth(context) * 0.12,
                  height: Config.getDeviceHeight(context) * 0.12,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  dashboardItem.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Config.getDeviceWidth(context) * 0.02,
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
                      fontSize: Config.getDeviceWidth(context) * 0.01,
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
