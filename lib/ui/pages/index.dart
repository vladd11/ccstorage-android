import 'package:ccstorage/storage_icons.dart';
import 'package:ccstorage/ui/pages/item_list.dart';
import 'package:ccstorage/ui/pages/robot_list.dart';
import 'package:flutter/material.dart';
import 'package:ccstorage/ui/api_widget.dart';
import 'package:ccstorage/ui/app_bar.dart';

import '../item.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  final String title = "Item";

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int screen = 0;
  List<Widget> screens = [
    const ItemList(),
    const RobotList(),
    const ItemList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(StorageIcons.chest), label: "Storage"),
            BottomNavigationBarItem(
                icon: Icon(StorageIcons.robot), label: "Robots"),
            BottomNavigationBarItem(
                icon: Icon(StorageIcons.craft), label: "Auto craft"),
          ],
          onTap: (value) => setState(() => screen = value),
          currentIndex: screen,
        ),
        appBar: StatusAppBar(widget.title),
        body: screens[screen]);
  }
}
