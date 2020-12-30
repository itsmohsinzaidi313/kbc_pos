import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          RaisedButton(
              child: Text('Ok'),
              onPressed: () {
                }
              ),
        ],
      ),
    );
  }
}
