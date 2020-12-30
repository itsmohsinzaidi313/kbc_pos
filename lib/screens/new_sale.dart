import 'package:draggable_floating_button/draggable_floating_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kbc_pos/shared/app_theme.dart';
import 'package:kbc_pos/shared/config.dart';

class NewSale extends StatefulWidget {
  @override
  _NewSaleState createState() => _NewSaleState();
}

class _NewSaleState extends State<NewSale> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var _appBar = AppTheme.appBarNormal(
      context: context,
      appBarTitle: 'New Sales',
      appBarElevation: 0.0,
      appBarBgColor: AppTheme.appBarColor,
    );
    return WillPopScope(
        child: Scaffold(
          key: _key,
          backgroundColor: Colors.grey[200],
          appBar: _appBar,
          body: Stack(
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      color: Colors.red,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: ListTile(
                              leading: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: 'model.leadingString'.isNotEmpty
                                      ? Colors.yellow.shade600
                                      : Colors.red,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'model.leadingString',
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: 'model.titleString'.isNotEmpty
                                      ? Colors.yellow.shade600
                                      : Colors.red,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text('model.titleString',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              trailing: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: ' model.trailingString'.isNotEmpty
                                      ? Colors.yellow.shade600
                                      : Colors.red,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('model.trailingString',
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    'Categories'.toUpperCase(),
                                    style: GoogleFonts.staatliches(
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 5.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  height:
                                      Config.getDeviceHeight(context) * 0.12,
                                  padding: EdgeInsets.only(top: 5),
                                  // decoration: BoxDecoration(border: Border.all(width: 2)),
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: getCategoryWidgets(
                                        /*model.lstCategory*/ null),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    'Items'.toUpperCase(),
                                    style: GoogleFonts.staatliches(
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 5.0,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.only(top: 5),
                                    // decoration: BoxDecoration(border: Border.all(width: 2)),
                                    child: GridView.count(
                                      crossAxisCount: 4,
                                      children: getItemsWidgets(
                                          /*model.lstItem*/ null,
                                          'categoryName'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: Config.getDeviceHeight(context),
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(5),
                                shape: BoxShape.rectangle,
                                border: Border(
                                  left: BorderSide(
                                    color: Colors.grey[300],
                                    width: 2,
                                  ),
                                  right: BorderSide(
                                    color: Colors.grey[300],
                                    width: 2,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.grey[300],
                                    width: 2,
                                  ),
                                  top: BorderSide(
                                    color: Colors.grey[300],
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: /* model.order.itemList.length*/ 1 > 0
                                  ? ListView(
                                      children: getCartItemsWidgets(List.from(
                                          /*model.order.itemList.reversed*/ null)),
                                    )
                                  : Container(
                                      alignment: Alignment.bottomCenter,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          // scale: 10,
                                          image: AssetImage(
                                            'assets/empty_cart.png',
                                          ),
                                        ),
                                      ),

                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              DraggableFloatingActionButton(
                backgroundColor: Colors.red,
                elevation: 5,
                tooltip: 'Submit Order',
                appContext: context,
                appBar: _appBar,
                offset: new Offset(
                  Config.getDeviceWidth(context) * 0.91,
                  Config.getDeviceHeight(context) * 0.72,
                ),
                child: Icon(
                  Icons.done_rounded,
                  size: 35,
                  color: Colors.red.shade100,
                ),
                onPressed: () {
                  /*model.order.itemList.length*/ 1 > 0
                      ? AppTheme.showAlertDialogOK(
                          context,
                          title: 'Success',
                          message: 'Order saved.',
                          onOK: () => _onFloatingButtonPressed(),
                        )
                      : AppTheme.showAlertDialogOK(
                          context,
                          title: 'Failed',
                          message: 'Please add Items to punch order',
                          onOK: () => Navigator.pop(context),
                        );
                },
              ),
            ],
          ),
        ),
        onWillPop: _onWillPop);
  }

  Future<bool> _onWillPop() async {
    bool isYes = false;
    bool type = await AppTheme.showAlertDialogYNFutureReturn(context,
        title: 'Question?',
        message: 'Are you sure?',
        onNo: () => Navigator.of(context).pop(false),
        onYes: () =>
            // OrderController(model.orderType).launchAndReplacement(context)
            true ? isYes = true : isYes = false);

    if (isYes && type) {
      if (/*model.titleString*/ ''.isNotEmpty) {
        Navigator.pop(context);
        return true;
      } else {
        Navigator.pop(context);
        // OrderController(model.orderType).launchAndReplacement(context);
      }
      return false;
    } else {
      return false;
    }
  }

  List<Widget> getCategoryWidgets(List<dynamic> lstCategory) {
    /*List<Widget> widgets = [];
    lstCategory.forEach((category) {
      if(_element.isEmpty){
        setState(() {
          _element = category.categoryName;
        });
      }
      widgets.add(
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: _element == category.categoryName ? Colors.white70 : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  categoryName = category.categoryName;
                  _element = category.categoryName;
                });
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.yellow.shade700,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 13,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade700,
                        radius: 9,
                      ),
                    ),
                  ),
                  Container(
                    height: Config.getDeviceHeight(context) * 0.1,
                    width: Config.getDeviceHeight(context) * 0.18,
                    child: Center(
                      child: Text(
                        category.categoryName.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntuCondensed(
                          color: Colors.red.shade700,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          wordSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
    return widgets;*/
    return [];
  }

  List<Widget> getItemsWidgets(List<dynamic> lstItem, String categoryName) {
    /*List<Widget> widgets = [];
    lstItem.forEach((item) {
      // if (categoryName.isEmpty) {
      //   categoryName = item.categoryName;
      // }
      if (item.categoryName == _element) {
        widgets.add(
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 3,
            color: Colors.white,
            child: InkWell(
              onTap: () {
                setState(() {
                  this.model.order.addItem(item);
                });
              },
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      height: Config.getDeviceHeight(context) * 0.2,
                      width: Config.getDeviceWidth(context) * 0.159,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: item.photo != null
                              ? NetworkImage(item.photo)
                              : AssetImage('assets/no_image1.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  item.photo == null
                      ? Align(
                          alignment: Alignment.center,
                          child: Text(
                            'No Image'.toUpperCase(),
                            style: GoogleFonts.anton(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Container(),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      height: Config.getDeviceHeight(context) * 0.094,
                      width: Config.getDeviceWidth(context) * 0.158,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  item.name.toUpperCase(),
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.ubuntuCondensed(
                                    color: Colors.grey.shade800,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0,
                                    wordSpacing: 0.5,
                                  ),
                                ),
                              ),
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'PKR ${double.parse(item.salePrice).toInt().toString()}',
                                    style: GoogleFonts.ubuntuCondensed(
                                      color: Colors.grey.shade500,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      wordSpacing: 1.0,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: Colors.yellow.shade900,
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: Colors.yellow.shade900,
                                      ),
                                      Icon(
                                        Icons.star_half_outlined,
                                        size: 10,
                                        color: Colors.yellow.shade900,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
    return widgets;*/
    return [];
  }

  List<Widget> getCartItemsWidgets(List<dynamic> lstItem) {
    /*List<Widget> widgets = [];
    lstItem.forEach((item) {
      widgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              model.order.addItem(item);
            });
          },
          child: Card(
            elevation: 4,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.yellow.shade700,
                radius: 16,
                child: CircleAvatar(
                  radius: 14,
                  backgroundImage: item.photo != null ? NetworkImage(item.photo) : AssetImage('assets/no_image1.jpg'),
                ),
              ),
              title: Text(
                  item.name.toUpperCase(),
                style: GoogleFonts.ubuntuCondensed(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  wordSpacing: 0.5,
                ),
              ),
              subtitle: Text(
                ' ${double.parse(item.salePrice).toInt().toString()} x ${item.quantity} '
                    '= ${(double.parse(item.salePrice).toInt() * int.parse(item.quantity)).toString()}',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 10,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.yellow.shade800,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    item.quantity = 1.toString();
                    this.model.order.removeItem(item);
                  });
                },
              ),
            ),
          ),
        ),
      );
    });
    return widgets;*/
  }

  void _onFloatingButtonPressed() async {
  }

}
