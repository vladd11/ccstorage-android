import 'package:ccstorage/ui/api_widget.dart';
import 'package:ccstorage/ui/item.dart';
import 'package:ccstorage/ui/robot.dart';
import 'package:flutter/material.dart';

class RobotList extends StatelessWidget {
  const RobotList({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiWidget.of(context).api;
    if (api.robots == null) api.getRobots();
    return (api.robots != null)
        ? ListView(
            children: api.robots!
                .map((item) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: Robot(isConnected: item.isConnected)))
                .toList(growable: false))
        : const Center(child: CircularProgressIndicator());
  }
}
