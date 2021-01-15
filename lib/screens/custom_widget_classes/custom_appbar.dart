import 'package:flutter/material.dart';
import 'package:kbc_pos/shared/app_theme.dart';
import 'package:kbc_pos/shared/config.dart';

class CustomAppBar extends StatelessWidget {
  final Widget searchBar;
  final Widget radioButtons;
  final String appBarTitle;
  final Function onBackPressed;

  CustomAppBar(
      {@required this.searchBar,
      @required this.radioButtons,
      @required this.appBarTitle,
      @required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Config.getDeviceHeight(context) * 0.28,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: Config.getDeviceHeight(context) * 0.15,
            color: AppTheme.appBarColor,
            child: Center(
              child: Text(
                appBarTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 0,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
                size: 20,
              ),
              onPressed: onBackPressed,
            ),
          ),
          Positioned(
            top: 45,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: Colors.grey[200],
                  width: 2,
                  style: BorderStyle.solid,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-3,-3),
                    blurRadius: 1,
                    spreadRadius: 0.5,
                  ),
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(3,3),
                    blurRadius: 5,
                    spreadRadius: 0.5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                      height: 50,
                      child: searchBar,
                    ),
                  ),
                  /*Expanded(
                    flex: 1,
                    child: radioButtons,
                  ),*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
