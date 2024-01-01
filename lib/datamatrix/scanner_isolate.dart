import 'dart:isolate';
import 'dart:ffi';
import 'package:camera/camera.dart';
import '../generated_bindings.dart';
import 'image_handler.dart';

void scan(SendPort port) {
  final inPort = ReceivePort();
  port.send(inPort.sendPort);

  final NativeLibrary dylib =
      NativeLibrary(DynamicLibrary.open('libflutter_zxing.so'));

  inPort.listen((message) {
    try {
      String o = handleImage(dylib, message as CameraImage);
      port.send(o);
    } on UnsupportedFormat {
      port.send(null);
    }
  });
}
