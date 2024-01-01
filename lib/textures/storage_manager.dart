import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

const s3texturePath = "https://";
class StorageManager {
  static Future<String> get _localPath async {
    return (await getApplicationCacheDirectory()).path;
  }

  static Future<File?> getTextureForItem(String name) async {
    try {
      final spl = name.split(":");
      if(spl.length != 2) {
        debugPrint("Invalid item name $name");
        return null;
      }
      final path = await _localPath;
      return File("$path/textures/${spl[0]}/${spl[1]}.png");
    } catch (e) {
      return null;
    }
  }

  Future<void> downloadTextures(String mod) async {

  }
}