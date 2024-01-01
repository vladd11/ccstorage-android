import 'package:ccstorage/ui/api_widget.dart';
import 'package:ccstorage/ui/item.dart';
import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  const ItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiWidget.of(context).api;
    return (api.counts != null)
        ? LayoutBuilder(
            builder: (context, constraints) => GridView.builder(
              scrollDirection: Axis.vertical,
              itemCount: api.counts!.length,
              itemBuilder: (context, index) => Item(api.counts![index]),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (constraints.maxWidth > 320)
                    ? constraints.maxWidth ~/ 56
                    : constraints.maxWidth ~/ 48,
                childAspectRatio: 1,
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
