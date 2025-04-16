import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class Constants {
  static const List<String> topics = [
    'Technology',
    'Business',
    'Sport',
    'Programming',
    'Entertainment',
    'Games',
    'Beauty',
    'Education'
  ];

  static const String defaultImageAssetPath = 'icon.png';
}

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.create(recursive: true);
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}
