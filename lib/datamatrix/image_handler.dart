import 'dart:ffi';
import 'package:ffi/ffi.dart' as ffi;
import '../generated_bindings.dart';
import '../main.dart' as head;
import 'dart:typed_data';

import 'package:camera/camera.dart';

class UnsupportedFormat implements Exception {
  const UnsupportedFormat([this.cause = "Unsupported camera format"]);

  final String cause;

  @override
  String toString() {
    return cause;
  }
}

// https://gist.github.com/Alby-o/fe87e35bc21d534c8220aed7df028e03
String handleImage(NativeLibrary dylib, CameraImage image) {
  final Pointer<Char> res;
  if (image.format.group == ImageFormatGroup.yuv420) {
    Uint8List list = image.planes[0].bytes;
    final buf = ffi.malloc.allocate<Uint8>(list.length);
    buf.asTypedList(list.length).setRange(0, list.length, list);

    res = dylib.readBarcode(buf, image.width, image.height,
        image.planes[0].bytesPerPixel ?? 1, image.planes[0].bytesPerRow);
    ffi.malloc.free(buf);
  } else if (image.format.group == ImageFormatGroup.bgra8888) {
    final bytes =
        _getBGRABytes(image.planes[0].bytes, image.width, image.height);
    final buf = ffi.malloc.allocate<Uint8>(bytes.length);
    for (int i = 0; i < bytes.length; ++i) {
      buf[i] = _getLuminance(bytes[i]);
    }
    res = dylib.readBarcode(
        buf, image.width, image.height, 1, image.width);
    ffi.malloc.free(buf);
  } else {
    throw const UnsupportedFormat();
  }

  String s = res.cast<ffi.Utf8>().toDartString();
  ffi.malloc.free(res);
  return s;
}

Uint32List _getBGRABytes(Uint8List bytes, int width, int height) {
  final Uint8List input =
      bytes is Uint32List ? Uint8List.view(bytes.buffer) : bytes;

  final Uint32List data = Uint32List(width * height);
  final Uint8List rgba = Uint8List.view(data.buffer);

  for (int i = 0, len = input.length; i < len; i += 4) {
    rgba[i + 0] = input[i + 2];
    rgba[i + 1] = input[i + 1];
    rgba[i + 2] = input[i + 0];
    rgba[i + 3] = input[i + 3];
  }
  return data;
}

/// Returns the luminance (grayscale) value of the [color].
int _getLuminance(int color) {
  final int r = _getRed(color);
  final int g = _getGreen(color);
  final int b = _getBlue(color);
  return _getLuminanceRgb(r, g, b);
}

/// Returns the luminance (grayscale) value of the color.
int _getLuminanceRgb(int r, int g, int b) =>
    (0.299 * r + 0.587 * g + 0.114 * b).round();

/// Get the red channel from the [color].
int _getRed(int color) => color & 0xff;

/// Get the green channel from the [color].
int _getGreen(int color) => (color >> 8) & 0xff;

/// Get the blue channel from the [color].
int _getBlue(int color) => (color >> 16) & 0xff;
