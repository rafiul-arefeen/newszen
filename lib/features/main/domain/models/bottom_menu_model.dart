import 'package:flutter/cupertino.dart';

class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.activeIcon,

    required this.body,
  });

  String icon;
  String activeIcon;

  Widget body;
}