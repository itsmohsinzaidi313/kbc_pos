import 'dart:async';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';


class AppTheme {
  static final Color appBarColor = Colors.red;
  static final Color dialogButtonColor = Colors.amberAccent;
  static final Color listTextColor = Colors.amber[400];
  static final Color appThemeColor = Colors.amber;

  static Widget appBarNormal(
      {BuildContext context,
      String appBarTitle,
      Color appBarBgColor,
      double appBarElevation}) {
    final appBar = AppBar(
      backgroundColor: appBarBgColor,
      elevation: appBarElevation == null ? 0.0 : appBarElevation,
      title: Text(appBarTitle),
      centerTitle: true,
    );
    return appBar;
  }

  static Widget appBarWithBadge(
      {BuildContext context,
      String appBarTitle,
      String badgeText,
      Color appBarBgColor,
      double appBarElevation,
      Function appBarOnTap}) {
    final appBar = AppBar(
      backgroundColor: appBarBgColor,
      elevation: appBarElevation == null ? 0.0 : appBarElevation,
      title: Text(appBarTitle),
      centerTitle: true,
      actions: <Widget>[
        InkWell(
          onTap: appBarOnTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Badge(
              child: Icon(Icons.shopping_cart, color: Colors.white, size: 40),
              badgeContent: Text(
                badgeText,
                style: TextStyle(color: Colors.white),
              ),
              badgeColor: Colors.red,
              toAnimate: true,
              animationType: BadgeAnimationType.fade,
            ),
          ),
        ),
      ],
    );
    return appBar;
  }

  static Widget textWidget(
      {String tText,
      double tFontSize,
      String tFontFamily,
      FontWeight tFontWeight,
      double tLetterSpacing,
      Color tTextColor}) {
    final myText = Text(
      tText,
      style: TextStyle(
        fontSize: tFontSize,
        fontFamily: tFontFamily,
        fontWeight: tFontWeight,
        letterSpacing: tLetterSpacing,
        color: tTextColor,
      ),
    );
    return myText;
  }

  static Future<Widget> showAlertDialog(BuildContext context,
          {String title,
          FontWeight fontWeight,
          double fontSize,
          Color color,
          bool barrier = true,
          Widget content,
          Widget widget,
          List<FlatButton> buttons}) =>
      showDialog(
          context: context,
          barrierDismissible: barrier,
          builder: (BuildContext context) => AlertDialog(
                title: Container(
                    color: Colors.red,
                    child: Center(
                      child: widget,
                    )),
                content: content,
                actions: buttons,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ));

  static ProgressDialog showProgressDialog(BuildContext context,
      {Widget widget,bool isDismissible = true}) {
    final spinKit = new SpinKitCircle(
      itemBuilder: (context, index) => DecoratedBox(
        decoration: BoxDecoration(
            color: appThemeColor,
          shape: BoxShape.circle,
        ),
      ),
    );
    ProgressDialog progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal,
        isDismissible: isDismissible,
        customBody: Container(
          height: 250,
          width: 100,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                spinKit,
                SizedBox(
                  height: 30,
                ),
                widget,
              ]),
        ));
    return progressDialog;
  }

  static circularProgressIndicator(Color color) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.amberAccent,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  static void showAlertDialogYN(BuildContext context,
      {String title, String message, Function onYes, Function onNo}) {
    showDialog(
        context: context,
        builder: (value) => AlertDialog(
            title: text(text: title, fontWeight: FontWeight.bold, fontSize: 20),
            content: text(text: message),
            actions: [
              FlatButton(
                  child: text(text: 'Yes', color: Colors.blue),
                  onPressed: onYes),
              FlatButton(
                  child: text(text: 'No', color: Colors.blue), onPressed: onNo)
            ],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8))));
  }

  static Future<bool> showAlertDialogYNFutureReturn(
      BuildContext context,
      {String title, String message, Function onYes, Function onNo}
      ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (value) => AlertDialog(
          title: text(text: title, fontWeight: FontWeight.bold, fontSize: 20),
          content: text(text: message),
          actions: [
            FlatButton(
                child: text(text: 'Yes', color: Colors.blue),
                onPressed: onYes),
            FlatButton(
                child: text(text: 'No', color: Colors.blue), onPressed: onNo)
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8))));
    return true;
  }

  static Text text(
      {String text,
      double fontSize = 15,
      FontWeight fontWeight = FontWeight.normal,
      Color color = Colors.black}) {
    return Text(
      text,
      style:
          textStyle(fontSize: fontSize, fontWeight: fontWeight, color: color),
    );
  }

  static TextStyle textStyle(
      {double fontSize = 18,
      FontWeight fontWeight = FontWeight.normal,
      Color color = Colors.black}) {
    return TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
  }

  static void showAlertDialogOK(BuildContext context,
      {String title, String message, Function onOK}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (value) => AlertDialog(
              title:
                  text(text: title, fontWeight: FontWeight.bold, fontSize: 20),
              content: text(text: message),
              actions: [
                FlatButton(
                    child: text(text: 'OK', color: Colors.blue),
                    onPressed: onOK),
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ));
  }

  static void showToast(String msg, BuildContext context){
    Toast.show(msg, context, backgroundColor: Colors.redAccent, textColor: Colors.white, duration: 2);
  }
}
