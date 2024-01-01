import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ccstorage/datamatrix/scanner_isolate.dart';
import 'package:ccstorage/ui/api_widget.dart';
import '../../io/api.dart' as api;
import '../../main.dart' as head;
import '../app_bar.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  final String title = "Scan robot's screen to connect";

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> with WidgetsBindingObserver {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  final _outPort = ReceivePort();
  late final SendPort _inPort;

  bool isBusy = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController();
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _outPort.listen((message) async {
      if (message != null) {
        isBusy = false;
        if (message is String) {
          if (message.isNotEmpty) {
            _outPort.close();
            ApiWidget.of(context).api.connectRobot(message);
            head.sharedPreferences.setBool("hasRobots", true);
            Navigator.pushReplacementNamed(context, "/robots");
          }
        } else {
          _inPort = message;
        }
      } else {
        print("Unsupported phone image format");
      }
    });
    Isolate.spawn(scan, _outPort.sendPort);
    _initializeCameraController();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StatusAppBar(widget.title),
      body: Stack(
        children: [
          FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller!);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
          Container(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
                onPressed: () {
                  return;
                },
                child: const SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("I want to enter code"),
                        Icon(Icons.keyboard_arrow_right)
                      ],
                    )),
              ))
        ],
      ),
    );
  }

  void _initializeCameraController() {
    _controller = CameraController(
      head.firstCamera,
      ResolutionPreset.veryHigh,
    );
    _initializeControllerFuture = _controller!.initialize();
    _initializeControllerFuture.then((_) {
      _controller!.startImageStream((image) {
        if (!isBusy) {
          isBusy = true;
          _inPort.send(image);
        }
      });
    });
  }
}
