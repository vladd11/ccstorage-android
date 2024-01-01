import 'package:flutter/material.dart';
import '/io/api.dart' as api;
import '/io/models.dart';

class Item extends StatelessWidget {
  final ItemCount item;

  const Item(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    List<String> spl = item.name.split(":");
    String path = "invalid.png";
    if (spl.length == 2) {
      path = "${spl[0]}/${spl[1]}.png";
    }

    return Stack(children: [
      Image.network(api.texturesUrl + path),
      Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {

            },
          ),
        ),
      ),
      Container(
        alignment: Alignment.bottomRight,
        child: Text(
          item.count.toString(),
          textAlign: TextAlign.end,
          style: TextStyle(
              fontSize: 32,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2
                ..color = Colors.white,
              height: 0.7),
        ),
      ),
      Container(
        alignment: Alignment.bottomRight,
        child: Text(
          item.count.toString(),
          textAlign: TextAlign.end,
          style: const TextStyle(fontSize: 32, height: 0.7, color: Colors.black),
        ),
      )
    ]);
  }
}
