import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'models.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;

const serverUrl =
    "wss://d5d9kek4ufcuvti32u1d.apigw.yandexcloud.net/ws?method=userLogin";

const texturesUrl = "https://storage.yandexcloud.net/textures/";

abstract class IApiException implements Exception {
  const IApiException([this.cause = "API exception"]);

  final String cause;

  @override
  String toString() {
    return cause;
  }
}

class NetworkException extends IApiException {
  const NetworkException() : super("No internet");
}

class Api {
  final Function onUpdate;

  Api({required this.onUpdate});

  List<ItemCount>? counts;
  List<Robot>? robots;

  WebSocketChannel? _wsChannel;
  bool connected = true;

  Future<void> connect() async {
    try {
      final result = await auth.signInAnonymously();
      _wsChannel = IOWebSocketChannel.connect(Uri.parse(serverUrl),
          headers: {
            "Authorization": "Bearer ${await result.user!.getIdToken()}"
          },
          connectTimeout: const Duration(seconds: 5));

      _wsChannel!.stream.listen((message) {
        final dec = jsonDecode(message);
        if (dec.containsKey("counts")) {
          counts = List<ItemCount>.from(
              dec["counts"].map<ItemCount>((e) => ItemCount.fromJson(e)));
        } else if (dec.containsKey("robots")) {
          robots = List<Robot>.from(
              dec["robots"].map<Robot>((e) => Robot.fromJson(e  )),
              growable: false);
        }
        onUpdate();
      }, onError: (e) {
        print(e);
        connected = false;
        onUpdate();
      });
      connected = true;
      onUpdate();

      _wsChannel!.sink.add(jsonEncode({"method": "getItems"}));
    } catch (e) {
      connected = false;
      onUpdate();
    }
  }

  void connectRobot(String id) {
    _wsChannel?.sink.add(jsonEncode({"method": "linkRobot", "robotId": id}));
  }

  void getItems() {
    _wsChannel?.sink.add(jsonEncode({"method": "getItems"}));
  }

  void getRobots() {
    _wsChannel?.sink.add(jsonEncode({"method": "getRobots"}));
  }

  Future<void> disconnect() async {
    connected = false;
    _wsChannel?.sink.close(status.goingAway);
  }
}
