import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kbc_pos/models/objects/order.dart';
import 'package:logger/logger.dart';

class Config {

  //region ___ALL APIS___
  static final String ipAddress = "192.168.18.250";
  // static final String ipAddress = "25.64.160.210";
  static final String commonAPI = "http://$ipAddress/kbc/data";
  static final String key = "?key=123";
  static final String getCategoryAPI = "$commonAPI/getcategories$key";
  static final String getItemsAPI = "$commonAPI/getitems$key&categoryid=";
  static final String getSessionsAPI = "$commonAPI/getsession$key";
  static final String getLocationsAPI = "$commonAPI/getlocation$key";
  static String loginUserAPI = "";
  static final String searchMembersAPI = "$commonAPI/searchmember$key&phrase=";
  static final String searchItemAPI = "$commonAPI/searchitems$key&phrase=";
  static final String sendOrderAPI = "$commonAPI/neworder$key";
  static final String getOrderAPI = "$commonAPI/getorders$key";
  static final String paymentOrderAPI = "$commonAPI/payorder$key";
  static final String deleteOrderAPI = "$commonAPI/deleteorder$key";

  static const String STATUS = "Status";
  static const String MESSAGE = "Message";
  static const String DATA = "Data";

  setLoginUserAPI(String username, String password){
    loginUserAPI = "$commonAPI/getuser$key&username=$username&password=$password";
  }

  getLoginUserAPI() => loginUserAPI;
  //endregion

  //region ___USER ID___
  static String _userId;
  static String get userId => _userId;
  static set userId(String value) => _userId = value;
  //endregion

  //region ___DEVICE KEY___
  static String _deviceKey;
  static String get deviceKey => _deviceKey;
  static set deviceKey(String value) => _deviceKey = value;
  //endregion

  //region ___isEditing FLAG___
  static int _isEditing;
  static int get isEditing => _isEditing;
  static set isEditing(int value) => _isEditing = value;
  //endregion

  //region ___SELECTED ORDER___
  static Order _selectedOrder;
  static Order get selectedOrder => _selectedOrder;
  static set selectedOrder(Order value) => _selectedOrder = value;
  //endregion

  static double getDeviceWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double getDeviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static final Logger log = new Logger(
    printer: PrettyPrinter(
        colors: true,
        errorMethodCount: 1,
        printEmojis: true,
        printTime: false,
        lineLength: 80,
        methodCount: 0),
  );

  static String getCurrentDateTime() {
    DateTime dateTime = DateTime.now();
    DateFormat formatDateTime = DateFormat.yMd().add_jm();
    String currentDateTime = formatDateTime.format(dateTime);
    return currentDateTime;
  }

  static String getCurrentDateTimeDBFormat() {
    DateTime dateTime = DateTime.now();
    DateFormat formatDateTime = DateFormat("yyyy-MM-dd HH:mm:ss");
    String currentDateTime = formatDateTime.format(dateTime);
    return currentDateTime;
  }

  static String getCurrentTime() {
    DateTime dateTime = DateTime.now();
    DateFormat formatDateTime = DateFormat("HH:mm:ss");
    String currentDateTime = formatDateTime.format(dateTime);
    return currentDateTime;
  }

  static int getCurrentYear() {
    DateTime dateTime = DateTime.now();
    DateFormat formatDateTime = DateFormat("yyyy");
    int currentYear = int.parse(formatDateTime.format(dateTime));
    return currentYear;
  }

  static String getCurrentShiftDate(String date) {
    DateFormat formatDateTime = DateFormat("yyyy-MM-dd");
    String currentDateTime = formatDateTime.format(DateTime.parse(date));
    return currentDateTime;
  }

  static String convertDateTimeToDate(DateTime date) {
    DateFormat formatDateTime = DateFormat("yyyy-MM-dd");
    String currentDateTime = formatDateTime.format(date);
    return currentDateTime;
  }

  static String getCurrentDate() {
    DateTime dateTime = DateTime.now();
    DateFormat formatDateTime = DateFormat("yyyy-MM-dd");
    String currentDate = formatDateTime.format(dateTime);
    return currentDate;
  }

  static String getCurrentTime24Format() {
    DateTime dateTime = DateTime.now();
    DateFormat formatDateTime = DateFormat("HH:mm:ss");
    String currentTime = formatDateTime.format(dateTime);
    return currentTime;
  }

}

enum DATABASE { STABLE, CREATE, UPGRADE, DOWNGRADE }
