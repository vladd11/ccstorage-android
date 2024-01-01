import 'package:flutter/material.dart';
import 'package:ccstorage/main.dart';

import 'api_widget.dart';

class StatusAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StatusAppBar(this.title, {super.key});

  final String title;

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        AppBar(
          title: Text(title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        if (!ApiWidget.of(context).api.connected)
          Container(
            width: double.infinity,
            height: 25,
            color: Colors.red,
            alignment: Alignment.center,
            child: const Text("No internet",
                style: TextStyle(color: Colors.white)),
          )
        else
          Container()
      ],
    );
  }
}
