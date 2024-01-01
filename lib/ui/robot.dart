import 'package:ccstorage/storage_icons.dart';
import 'package:flutter/material.dart';

enum RobotActions {
  chests(widget: Text("")),
  scan(widget: Text("Scan your robot's environment"));

  const RobotActions({required this.widget});
  final Widget widget;
}

class Robot extends StatefulWidget {
  final bool isAdvanced, isConnected;
  final String name;
  final int chests, items;

  const Robot({super.key,
    this.isAdvanced = false,
    this.isConnected = false,
    this.name = "Andy",
    this.chests = 1,
    this.items = 1});

  @override
  State<StatefulWidget> createState() {
    return _RobotState();
  }
}

class _RobotState extends State<Robot> {
  RobotActions robotAction = RobotActions.chests;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Image.asset("images/turtle_advanced.png"),
                Row(
                  children: [
                    Text(
                      "Andy",
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineSmall,
                    ),
                    (widget.isConnected)
                        ? const Text(
                      " (connected)",
                      style: TextStyle(color: Colors.green),
                    )
                        : const Text(
                      " (not connected)",
                      style: TextStyle(color: Colors.redAccent),
                    )
                  ],
                ),
              ],
            ),
            SegmentedButton<RobotActions>(
              showSelectedIcon: false,
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero
                  ),
                ),
              ),
              segments: const [
                ButtonSegment<RobotActions>(value: RobotActions.chests,
                    label: Text("Chests"),
                    icon: Icon(StorageIcons.chest)),
                ButtonSegment<RobotActions>(value: RobotActions.scan,
                    label: Text("Scan"),
                    icon: Icon(Icons.search, size: 22,))
              ],
              selected: <RobotActions>{robotAction},
              onSelectionChanged: (Set<RobotActions> newSelection) {
                setState(() {
                  robotAction = newSelection.first;
                });
              },
            ),
            robotAction.widget
          ],
        ));
  }
}
