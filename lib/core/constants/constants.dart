import 'dart:io';

import 'package:flutter/services.dart';
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

  static const String defaultImageAssetPath = 'assets/black_banner.png';

  static Future<File> getDefaultImageFile() async {
    try {
      // 1. Загружаем asset как ByteData
      final byteData = await rootBundle.load(defaultImageAssetPath);

      // 2. Получаем временную директорию
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/black_banner.png');

      // 3. Записываем данные в файл
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      return tempFile;
    } catch (e) {
      throw Exception("Failed to load default image: $e");
    }
  }
}
